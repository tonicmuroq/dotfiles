import hashlib
import json
import os
import re
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from claude_memory import MAX_MEMORY_BYTES, hook_output, memory_context


class ClaudeMemoryTest(unittest.TestCase):

    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name).resolve()
        self.config = self.root / "claude"
        self.workspace = self.root / "workspace"
        self.workspace.mkdir()

    def write_memory(self, directory, content):
        encoded = re.sub(r"[^a-zA-Z0-9_-]", "-", str(directory))
        file = self.config / "projects" / encoded / "memory/MEMORY.md"
        file.parent.mkdir(parents=True, exist_ok=True)
        file.write_text(content)
        return file

    def git(self, *args):
        subprocess.run(
            ["git", *map(str, args)],
            check=True,
            capture_output=True,
            env={**os.environ, "GIT_CONFIG_GLOBAL": os.devnull, "GIT_CONFIG_NOSYSTEM": "1"},
        )

    def test_nearest_memory_and_parent_fallback(self):
        project = self.workspace / "box"
        (project / "api").mkdir(parents=True)
        self.write_memory(self.workspace, "workspace notes")
        self.assertIn("workspace notes", memory_context(project, self.config))
        self.write_memory(project, "box notes")
        context = memory_context(project / "api", self.config)
        self.assertIn("box notes", context)
        self.assertNotIn("workspace notes", context)

    def test_worktree_uses_main_repository_before_shared_parent(self):
        main, worktree = self.workspace / "box", self.workspace / "box-feature"
        self.git("init", main)
        self.git("-C", main, "-c", "user.name=Test", "-c", "user.email=test@example.invalid", "commit", "--allow-empty", "-m", "init")
        self.git("-C", main, "worktree", "add", "--detach", worktree)
        (worktree / "api").mkdir()
        self.write_memory(self.workspace, "workspace notes")
        self.write_memory(main, "main repository notes")
        context = memory_context(worktree / "api", self.config)
        self.assertIn("main repository notes", context)
        self.assertNotIn("workspace notes", context)
        self.write_memory(worktree, "worktree notes")
        self.assertIn("worktree notes", memory_context(worktree, self.config))

    def test_bounded_read_preserves_file_and_marks_truncation(self):
        file = self.write_memory(self.workspace, "记忆" * MAX_MEMORY_BYTES)
        before = hashlib.sha256(file.read_bytes()).digest()
        context = memory_context(self.workspace, self.config)
        self.assertIn("Only the first", context)
        self.assertIn("Do not edit", context)
        self.assertLess(len(context.encode()), MAX_MEMORY_BYTES + 1024)
        self.assertEqual(hashlib.sha256(file.read_bytes()).digest(), before)

    def test_missing_empty_memory_and_unsupported_event_are_noops(self):
        self.assertEqual(memory_context(self.workspace, self.config), "")
        self.write_memory(self.workspace, "\n ")
        self.assertEqual(memory_context(self.workspace, self.config), "")
        self.assertEqual(hook_output({"cwd": str(self.workspace), "hook_event_name": "Stop"}, self.config), {})
        self.assertEqual(hook_output({"cwd": ".", "hook_event_name": "SessionStart"}, self.config), {})

    def test_command_uses_custom_claude_config_for_both_events(self):
        self.write_memory(self.workspace, "custom config notes")
        script = Path(__file__).with_name("claude_memory.py")
        for event in ("SessionStart", "SubagentStart"):
            result = subprocess.run(
                [sys.executable, str(script)],
                input=json.dumps({"cwd": str(self.workspace), "hook_event_name": event}),
                capture_output=True,
                text=True,
                env={**os.environ, "CLAUDE_CONFIG_DIR": str(self.config)},
                check=True,
            )
            output = json.loads(result.stdout)["hookSpecificOutput"]
            self.assertEqual(output["hookEventName"], event)
            self.assertIn("custom config notes", output["additionalContext"])

    def test_invalid_json_fails_open(self):
        result = subprocess.run(
            [sys.executable, str(Path(__file__).with_name("claude_memory.py"))],
            input="invalid json",
            capture_output=True,
            text=True,
            check=True,
        )
        self.assertEqual(json.loads(result.stdout), {})


if __name__ == "__main__":
    unittest.main()
