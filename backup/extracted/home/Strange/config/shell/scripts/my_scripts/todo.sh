#!/bin/bash
todo() {
    local file="$HOME/purgatory/notes/my_notes/todo.md"
    [[ -f "$file" ]] || touch "$file"

    case "$1" in
        -e|--edit)
            $EDITOR "$file"
            ;;
    -a|--add)
        shift
        local text="$*"
        if [[ -z "$text" ]]; then
            echo "Usage: todo -a <task text>"
            return 1
        fi
        local count
        count=$(grep -c '^[0-9]\+\. \[ \]' "$file" 2>/dev/null) || count=0
        local num=$((count + 1))
        echo "$num. [ ] $text" >> "$file"
        echo "Added: $num. [ ] $text"
        ;;
        "" )
            less +Gg "$file"
            ;;
        * )
            echo "Usage: todo [-e|--edit] [-a|--add <text>]"
            ;;
    esac
}
