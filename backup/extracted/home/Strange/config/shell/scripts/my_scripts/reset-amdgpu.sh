#!/bin/bash
logfile="$HOME/.local/share/reset-amdgpu.log"

echo "[REFRESH] Forcing display redraw at $(date)" >> "$logfile"

# Give time after resume
sleep 2

# Try to disable and re-enable all outputs
if swaymsg output "*" disable && sleep 1 && swaymsg output "*" enable; then
    echo "[OK] Display refreshed via swaymsg." >> "$logfile"
    notify-send "Display Refreshed" "Outputs toggled successfully."
else
    echo "[FAIL] Display refresh failed." >> "$logfile"
    notify-send "Display Refresh Failed" "Could not toggle outputs."
fi
