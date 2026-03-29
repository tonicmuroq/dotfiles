#!/bin/sh
# Claude Code status line: dir, git branch, model, context remaining, quota usage
# Color theme: Kanagawa — warm ink tones inspired by rebelot/kanagawa.nvim
# Uses printf with true-color (24-bit) escape sequences: \033[38;2;R;G;Bm

input=$(cat)

# single jq call — output shell-safe variable assignments
eval "$(echo "$input" | jq -r '
  @sh "cwd=\(.workspace.current_dir // .cwd // "")",
  @sh "model=\(.model.display_name // "")",
  "remaining=\(.context_window.remaining_percentage // "")",
  "input_tokens=\(.context_window.current_usage.input_tokens // "")",
  "cache_create=\(.context_window.current_usage.cache_creation_input_tokens // 0)",
  "cache_read=\(.context_window.current_usage.cache_read_input_tokens // 0)",
  "five_h=\(.rate_limits.five_hour.used_percentage // "")",
  "seven_d=\(.rate_limits.seven_day.used_percentage // "")"
')"

# ANSI true-color escape sequences
RESET=$(printf '\033[0m')
C_DIR=$(printf '\033[38;2;200;192;147m')    # oldWhite   #C8C093
C_GIT=$(printf '\033[38;2;126;156;216m')    # waveBlue   #7E9CD8
C_DIRTY=$(printf '\033[38;2;230;195;132m')  # carpYellow #E6C384
C_MODEL=$(printf '\033[38;2;149;127;184m')  # oniViolet  #957FB8
C_CTX=$(printf '\033[38;2;152;187;108m')    # springGreen #98BB6C
C_SEP=$(printf '\033[38;2;113;124;124m')    # katanaGray #717C7C

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

# format token count: 1234 -> 1.2k, 1234567 -> 1.2M
format_tokens() {
  n=$1
  if [ "$n" -ge 1000000 ] 2>/dev/null; then
    whole=$((n / 1000000))
    frac=$(( (n % 1000000) / 100000 ))
    printf "%d.%dM" "$whole" "$frac"
  elif [ "$n" -ge 1000 ] 2>/dev/null; then
    whole=$((n / 1000))
    frac=$(( (n % 1000) / 100 ))
    printf "%d.%dk" "$whole" "$frac"
  else
    printf "%s" "$n"
  fi
}

# dynamic color by remaining percentage
color_by_remaining() {
  r=$1
  if [ "$r" -le 15 ] 2>/dev/null; then
    printf '\033[38;2;210;126;153m'   # sakuraPink  — critical
  elif [ "$r" -le 35 ] 2>/dev/null; then
    printf '\033[38;2;255;160;102m'   # surimiOrange — warning
  fi
  # else: caller uses its own default color
}

# context remaining with dynamic color
ctx_info=""
if [ -n "$remaining" ]; then
  remaining_int=$(printf "%.0f" "$remaining" 2>/dev/null || echo "$remaining" | cut -d. -f1)
  C_CTX_DYN=$(color_by_remaining "$remaining_int")
  : "${C_CTX_DYN:=$C_CTX}"
  tok_str=""
  if [ -n "$input_tokens" ]; then
    used_tokens=$(( input_tokens + cache_create + cache_read ))
    if [ "$used_tokens" -gt 0 ] 2>/dev/null; then
      tok_str="$(format_tokens "$used_tokens") "
    fi
  fi
  ctx_info="${SEP}${C_CTX_DYN}ctx ${tok_str}(${remaining}% left)${RESET}"
fi

# rate limit usage (5h and 7d windows) — show remaining%, dynamic color
C_RATE=$(printf '\033[38;2;122;168;159m')  # waveAqua #7AA89F — default rate color
rate_info=""
if [ -n "$five_h" ]; then
  five_h_int=$(printf "%.0f" "$five_h" 2>/dev/null || echo "$five_h" | cut -d. -f1)
  five_h_left=$((100 - five_h_int))
  C_5H=$(color_by_remaining "$five_h_left")
  : "${C_5H:=$C_RATE}"
  rate_info="${SEP}${C_5H}5h (${five_h_left}% left)${RESET}"
fi
if [ -n "$seven_d" ]; then
  seven_d_int=$(printf "%.0f" "$seven_d" 2>/dev/null || echo "$seven_d" | cut -d. -f1)
  seven_d_left=$((100 - seven_d_int))
  C_7D=$(color_by_remaining "$seven_d_left")
  : "${C_7D:=$C_RATE}"
  rate_info="${rate_info}${SEP}${C_7D}7d (${seven_d_left}% left)${RESET}"
fi

printf "%s%s%s%s%s%s%s%s%s\n" \
  "$C_DIR" "$short_dir" "$RESET" \
  "$git_info" \
  "$SEP" "$C_MODEL" "$model" "$RESET" \
  "${ctx_info}${rate_info}"
