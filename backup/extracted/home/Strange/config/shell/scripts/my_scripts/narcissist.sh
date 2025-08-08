#!/bin/bash

# === Prevent double sourcing ===
[[ -n "$__STRANGE_SOURCED" ]] && return
__STRANGE_SOURCED=1

# === STRANGE Failure Handlers ===
on_error() {
  echo -e "\n[!] Execution failed... STRANGE expected perfection."
}

on_interrupt() {
  echo -e "\n[!] Rage quit detected... STRANGE is furious."
}


# === Command Wrapper ===
invoke() {
  if ! "$@"; then
    local code=$?
    echo -e "\n[!] Command failed: $*"
    echo "[!] STRANGE is disappointed by your incompetence. Elevate yourself."
    echo "[*] Exit code: $code"
    return $code
  fi
}

# === Sudo Wrapper ===
please() {
  if [[ "$EUID" -eq 0 ]]; then
    invoke "$@"
  else
    sudo env STRANGE_WRAP=1 bash -c '
      source /home/Strange/.config/sway/scripts/my_scripts/narcissist.sh
      invoke "$@"
    ' bash "$@"
  fi
}

# === Unknown Command Handler ===
command_not_found_handle() {
  echo "STRANGE does not recognize that peasant command: '$1'" >&2
  return 127
}

# === Secret Fail Unlock ===
unalias forgive 2>/dev/null
alias forgive='sudo faillock --user "$USER" --reset'


# Fake Vim-style shell commands
function :q { exit; }
function :q! { exit; }

function :wq {
  echo "[bash] E492: Not an editor"
}

function :w {
  echo "[bash] E212: Can't open file for writing"
}

# === Interactive Shell Only ===
if [[ $- == *i* ]]; then
  trap on_error ERR

  __strange_check_interrupt() {
    local last=$?
    if [[ $last -eq 130 ]]; then
      on_interrupt
    fi
    return $last
  }

  PROMPT_COMMAND='__strange_check_interrupt'
fi
