#!/bin/bash

THEMES_DIR="/usr/share/themes"
ICONS_DIR="/usr/share/icons"
GTK3_FILE="$HOME/.config/gtk-3.0/settings.ini"

# If --list → list themes and icons
if [[ "$1" == "--list" ]]; then
    echo "Available GTK Themes:"
    ls "$THEMES_DIR"
    echo
    echo "Available Icon Themes:"
    ls "$ICONS_DIR"
    exit 0
fi

# If no arguments → open settings.ini
if [[ $# -eq 0 ]]; then
    ${EDITOR:-vim} "$GTK3_FILE"
    exit 0
fi

