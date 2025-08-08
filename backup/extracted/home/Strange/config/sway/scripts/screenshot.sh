#!/bin/bash

# Define output file path with timestamp
output="$HOME/Pictures/screenshots/shot_$(date +%Y-%m-%d-%H-%M-%S).png"

# Create output folder if missing
mkdir -p "$HOME/Pictures/screenshots"

# Screenshot function
screenshot() {
    if [ "$1" = "region" ]; then
        if grim -g "$(slurp)" "$output"; then
            notify-send "Screenshot saved" "$output"
            wl-copy < "$output"
        else
            notify-send "Screenshot cancelled"
            exit 1
        fi
    elif [ "$1" = "full" ]; then
        if grim "$output"; then
            notify-send "Screenshot saved" "$output"
            wl-copy < "$output"
        else
            notify-send "Screenshot cancelled"
            exit 1
        fi
    else
        echo "Usage: $0 {region|full}"
        exit 1
    fi
}

# Call the function with the first argument passed to the script
screenshot "$1"

