#!/bin/bash

# Check if MPD is running
if ! mpc status &>/dev/null; then
    exit 0
fi

status=$(mpc status | sed -n '2p' | awk '{print $1}' | tr -d '[]')

if [ "$status" != "playing" ] && [ "$status" != "paused" ]; then
    exit 0  # Hide if stopped
fi

song=$(mpc current)
icon=""
[ "$status" == "playing" ] && icon=" \$"

# Shorten song name if too long
max_len=20
if [ ${#song} -gt $max_len ]; then
    song="${song:0:$max_len} "
fi

echo "{\"text\": \"${icon} ${song}\", \"tooltip\": \"${status^}:$(mpc current)\"}"
