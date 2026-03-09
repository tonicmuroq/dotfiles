#!/bin/sh
# Claude Code status line: dir, git branch, model, context remaining, quota usage
# Color theme: Kanagawa — warm ink tones inspired by rebelot/kanagawa.nvim
# Uses printf with true-color (24-bit) escape sequences: \033[38;2;R;G;Bm

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Build ANSI true-color escape sequences via printf (works correctly in POSIX sh)
RESET=$(printf '\033[0m')
C_DIR=$(printf '\033[38;2;200;192;147m')    # oldWhite   #C8C093 — warm muted white
C_GIT=$(printf '\033[38;2;126;156;216m')    # waveBlue   #7E9CD8 — calm blue
C_DIRTY=$(printf '\033[38;2;230;195;132m')  # carpYellow #E6C384 — warm yellow
C_MODEL=$(printf '\033[38;2;149;127;184m')  # oniViolet  #957FB8 — soft purple
C_CTX=$(printf '\033[38;2;152;187;108m')    # springGreen #98BB6C — muted green
C_USAGE=$(printf '\033[38;2;122;168;159m')  # waveAqua   #7AA89F — teal
C_SEP=$(printf '\033[38;2;113;124;124m')    # katanaGray #717C7C — subtle grey

SEP="${C_SEP} · ${RESET}"

# short dir (replace $HOME with ~)
short_dir=$(echo "$cwd" | sed "s|^$HOME|~|")

# git branch and dirty status
git_info=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    dirty=""
    if ! git -C "$cwd" diff --quiet 2>/dev/null || ! git -C "$cwd" diff --cached --quiet 2>/dev/null; then
      dirty="${C_DIRTY}*${RESET}"
    fi
    git_info="${SEP}${C_GIT}${branch}${RESET}${dirty}"
  fi
fi

# context remaining with dynamic color based on level
ctx_info=""
if [ -n "$remaining" ]; then
  remaining_int=$(printf "%.0f" "$remaining" 2>/dev/null || echo "$remaining" | cut -d. -f1)
  if [ "$remaining_int" -le 15 ] 2>/dev/null; then
    C_CTX_DYN=$(printf '\033[38;2;210;126;153m')  # sakuraPink  #D27E99 — soft pink/red (critical)
  elif [ "$remaining_int" -le 35 ] 2>/dev/null; then
    C_CTX_DYN=$(printf '\033[38;2;255;160;102m')  # surimiOrange #FFA066 — warm orange (warning)
  else
    C_CTX_DYN="$C_CTX"                             # springGreen — plenty remaining
  fi
  ctx_info="${SEP}${C_CTX_DYN}ctx ${remaining}%${RESET}"
fi

# quota usage from environment variable
usage_info=""
if [ -n "$CLAUDE_CODE_USAGE_PERCENT" ]; then
  usage_info="${SEP}${C_USAGE}usage ${CLAUDE_CODE_USAGE_PERCENT}%${RESET}"
fi

printf "%s%s%s%s%s%s%s%s%s\n" \
  "$C_DIR" "$short_dir" "$RESET" \
  "$git_info" \
  "$SEP" "$C_MODEL" "$model" "$RESET" \
  "${ctx_info}${usage_info}"
