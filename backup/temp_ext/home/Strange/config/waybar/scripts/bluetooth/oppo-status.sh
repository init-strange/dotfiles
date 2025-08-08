#!/bin/bash

MAC="08:12:87:3C:34:00" # your device MAC

if ! bluetoothctl info "$MAC" | grep -q "Connected: yes"; then
    exit 0  # Output nothing, hides module in Waybar
fi

battery=$(bluetoothctl info "$MAC" | grep -i "Battery Percentage" | grep -oP '\(\K[0-9]+')

if [ -n "$battery" ]; then
    echo "{\"text\": \" ${battery}%\", \"tooltip\": \"Bluetooth Battery: ${battery}%\"}"
fi
