#!/bin/bash

wallDIR="$HOME/Downloads/Firefox_Downloads/pictures/"

# Get all image paths sorted naturally
mapfile -t ALL_PICS < <(find "$wallDIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | sort -V)

# Build menu
CHOICES=("[r] Random Wallpaper" "[x] No Wallpaper")
for path in "${ALL_PICS[@]}"; do
    name=$(basename "$path")
    CHOICES+=("   $name")
done

# Rofi menu
selected=$(printf "%s\n" "${CHOICES[@]}" | rofi -dmenu -p "Choose Wallpaper")

# Handle clear
if [[ "$selected" == "[x] No Wallpaper" ]]; then
    pkill swaybg
    exit 0
fi

# Handle random
if [[ "$selected" == "[r] Random Wallpaper" ]]; then
    if [[ ${#ALL_PICS[@]} -gt 0 ]]; then
        selected_path="${ALL_PICS[RANDOM % ${#ALL_PICS[@]}]}"
        pkill swaybg
        swaybg -i "$selected_path" -m fill &
        exit 0
    else
        notify-send "No wallpapers found"
        exit 1
    fi
fi

# Otherwise match filename
selected_name="${selected##* }"  # strip marker
for path in "${ALL_PICS[@]}"; do
    if [[ "$(basename "$path")" == "$selected_name" ]]; then
        pkill swaybg
        swaybg -i "$path" -m fill &
        exit 0
    fi
done

