#!/usr/bin/env bash

set -euo pipefail

# Directory containing wallpaper images
WALLPAPER_DIR="$HOME/Downloads/Firefox_Downloads/pictures"

# File to store the current wallpaper path
CURRENT_WALLPAPER_FILE="$HOME/.current_wallpaper"

# Get current wallpaper from file (if exists)
current_wallpaper=$(cat "$CURRENT_WALLPAPER_FILE" 2>/dev/null || true)

# Get list of wallpapers
mapfile -t wallpapers < <(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' \))
if [ "${#wallpapers[@]}" -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR" >&2
    exit 1
fi

# Build choices
choices=("[r] Random wallpaper")
if [ -n "$current_wallpaper" ] && [ -f "$current_wallpaper" ]; then
    choices+=("[>] Current: $(basename "$current_wallpaper")")
fi
choices+=("${wallpapers[@]}")

# Functions
resolve_selection() {
    local selection="$1"
    if [ "$selection" = "[r] Random wallpaper" ]; then
        shuf -n1 <<< "$wallpapers_str"
    elif [[ "$selection" == "[>] Current:"* ]]; then
        echo "$current_wallpaper"
    else
        echo "$selection"
    fi
}

set_wallpaper() {
    local path="$1"
    # Check if the path exists before setting
    if [ ! -f "$path" ]; then
        echo "Error: Wallpaper file '$path' does not exist." >&2
        return 1
    fi
    # Set wallpaper for all outputs
    if ! swaymsg output '*' bg "$path" fill &>/dev/null; then
        echo "Error: Failed to set wallpaper with swaymsg." >&2
        return 1
    fi
    # Update current wallpaper file
    printf '%s\n' "$path" > "$CURRENT_WALLPAPER_FILE"
}

# Export functions and variables
export -f resolve_selection set_wallpaper
export current_wallpaper
export wallpapers_str=$(printf '%s\n' "${wallpapers[@]}")

### Launch fzf
##selected=$(printf '%s\n' "${choices[@]}" | fzf \
##    --prompt="Wallpaper: " \
##    --height=40% --border --ansi \
##    --bind 'change:execute-silent(set_wallpaper "$(resolve_selection {})")' \
##    --bind 'up:up+execute-silent(set_wallpaper "$(resolve_selection {})")' \
##    --bind 'down:down+execute-silent(set_wallpaper "$(resolve_selection {})")')
##
# Launch fzf

# Temporarily disable "exit on error"
set +e
selected=$(printf '%s\n' "${choices[@]}" | fzf \
    --prompt="Wallpaper: " \
    --height=40% --border --ansi \
    --bind 'change:execute-silent(set_wallpaper "$(resolve_selection {})")' \
    --bind 'up:up+execute-silent(set_wallpaper "$(resolve_selection {})")' \
    --bind 'down:down+execute-silent(set_wallpaper "$(resolve_selection {})")')
fzf_exit=$?
set -e

# If fzf aborted (Esc/Ctrl+C) or nothing selected
if [[ $fzf_exit -ne 0 || -z "$selected" ]]; then
    kitty @ close-window --match title:WallpaperPicker &>/dev/null || kitty @ close-window || true
    exit 0
fi

# Set final wallpaper
final_path=$(resolve_selection "$selected")
if [ -f "$final_path" ]; then
    set_wallpaper "$final_path"
else
    echo "Invalid selection: $final_path is not a file" >&2
fi

# Always close Kitty window
kitty @ close-window --match title:WallpaperPicker &>/dev/null || kitty @ close-window || true
exit 0
