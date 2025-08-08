# --- FZF Insert: Files or Directories (Ctrl+F) ---
__fzf_file_insert() {
  local selected
  selected=$(fzf --multi)
  if [[ -n "$selected" ]]; then
    local insert=""
    while IFS= read -r line; do
      insert+="\"$line\" "
    done <<< "$selected"
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${insert}${READLINE_LINE:$READLINE_POINT}"
    READLINE_POINT=$(( READLINE_POINT + ${#insert} ))
  fi
}
bind -x '"\C-f": __fzf_file_insert'

# --- FZF Insert: Directories Only (Ctrl+D) ---
__fzf_dir_insert() {
  local selected
  selected=$(find . -type d 2>/dev/null | fzf --multi)
  if [[ -n "$selected" ]]; then
    local insert=""
    while IFS= read -r dir; do
      insert+="\"$dir\" "
    done <<< "$selected"
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${insert}${READLINE_LINE:$READLINE_POINT}"
    READLINE_POINT=$(( READLINE_POINT + ${#insert} ))
  fi
}
bind -x '"\e[99~":"__fzf_dir_insert"'

# --- FZF Insert: Bash History (Ctrl+H) ---
__fzf_history_insert() {
  local selected
  selected=$(history | fzf --multi --reverse| sed 's/ *[0-9]* *//')
  if [[ -n "$selected" ]]; then
    local insert=""
    while IFS= read -r cmd; do
      insert+="$cmd; "
    done <<< "$selected"
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${insert}${READLINE_LINE:$READLINE_POINT}"
    READLINE_POINT=$(( READLINE_POINT + ${#insert} ))
  fi
}
bind -x '"\C-h": __fzf_history_insert'
