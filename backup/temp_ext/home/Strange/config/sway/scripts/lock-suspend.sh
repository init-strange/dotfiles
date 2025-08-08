#!/bin/bash

swaylock \
  -c 1c1c1c \
  --ignore-empty-password \
  --indicator-caps-lock \
  --key-hl-color ff5555ff \
  --ring-color 44475a88 \
  --inside-color 282a36cc \
  --line-color 6272a4ff \
  --text-color f8f8f2ff &

# wait for swaylock to fully engage
sleep 0.8

# suspend cleanly
systemctl suspend
