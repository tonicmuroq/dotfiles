#!/usr/bin/env python3

import json
import os
import re
import subprocess
import sys
from pathlib import Path

MAX_MEMORY_BYTES = 16_384


def project_roots(cwd: Path) -> tuple[Path, Path]:
    try:
        result = subprocess.run(
            ["git", "-C", str(cwd), "rev-parse", "--path-format=absolute", "--show-toplevel", "--git-common-dir"],
            capture_output=True,
            text=True,
            timeout=1,
            check=True,
        )
        checkout, common = (Path(line).resolve() for line in result.stdout.splitlines())
        return checkout, common.parent if common.name == ".git" else checkout
    except (OSError, ValueError, subprocess.SubprocessError):
        return cwd, cwd


def memory_candidates(cwd: Path, config_dir: Path) -> list[Path]:
    checkout, main = project_roots(cwd)
    local = []
    for directory in (cwd, *cwd.parents):
        local.append(directory)
        if directory == checkout:
            break
    directories = dict.fromkeys([*local, main, *main.parents, *checkout.parents])
    return [config_dir / "projects" / re.sub(r"[^a-zA-Z0-9_-]", "-", str(p)) / "memory/MEMORY.md" for p in directories]


def memory_context(cwd: Path, config_dir: Path) -> str:
    for file in memory_candidates(cwd, config_dir):
        if not file.is_file():
            continue
        with file.open("rb") as source:
            raw = source.read(MAX_MEMORY_BYTES + 1)
        content = raw[:MAX_MEMORY_BYTES].decode("utf-8", errors="replace").strip()
        if not content:
            continue
        context = [
            "# Claude Code project memory (read-only)",
            f"Source: {json.dumps(str(file), ensure_ascii=False)}",
            "These are historical notes; current user instructions and AGENTS.md take precedence.",
            "Do not edit, consolidate, or write back to Claude memory. Read linked topic files only when relevant.",
        ]
        if len(raw) > MAX_MEMORY_BYTES:
            context.append(f"Only the first {MAX_MEMORY_BYTES} bytes are included; read the source file if more is needed.")
        context.extend(["", "<claude_code_memory>", content, "</claude_code_memory>"])
        return "\n".join(context)
    return ""


def hook_output(payload: dict, config_dir: Path) -> dict:
    event = payload.get("hook_event_name")
    cwd = payload.get("cwd")
    if event not in ("SessionStart", "SubagentStart") or not isinstance(cwd, str) or not Path(cwd).is_absolute():
        return {}
    context = memory_context(Path(cwd).resolve(), config_dir)
    if not context:
        return {}
    return {"hookSpecificOutput": {"hookEventName": event, "additionalContext": context}}


def main() -> None:
    output = {}
    try:
        payload = json.load(sys.stdin)
        config_dir = Path(os.environ.get("CLAUDE_CONFIG_DIR") or Path.home() / ".claude").expanduser().resolve()
        if isinstance(payload, dict):
            output = hook_output(payload, config_dir)
    except (OSError, ValueError) as exc:
        print(f"claude_memory_skipped, error={exc}", file=sys.stderr)
    print(json.dumps(output, ensure_ascii=False))


if __name__ == "__main__":
    main()
