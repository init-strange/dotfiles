#!/bin/bash
if pgrep -f "kitty.*Moosic_Player" >/dev/null; then
    pkill -f "kitty.*Moosic_Player"
else
    kitty --class Moosic_Player -T Moosic_Player bash -i -c 'source ~/.bashrc; music_menu' &
fi
