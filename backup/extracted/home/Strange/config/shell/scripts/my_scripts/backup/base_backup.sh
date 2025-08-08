#!/bin/bash
set -euo pipefail

BACKUP_DIR=/home/Strange/Backup
mkdir -p "$BACKUP_DIR"

paths=(
  "/home/Strange/purgatory"
  "/home/Strange/.config/"
  "/home/Strange/.config/Thunar"
  "/home/Strange/.config/git"
  "/home/Strange/.config/gtk-3.0"
  "/home/Strange/.config/gtk-4.0"
  "/home/Strange/.config/kitty"
  "/home/Strange/.config/nvim"
  "/home/Strange/.config/mpd"
  "/home/Strange/.config/mpv"
  "/home/Strange/.config/ncmpcpp"
  "/home/Strange/.config/rofi"
  "/home/Strange/.config/sway"
  "/home/Strange/.config/mako"
  "/home/Strange/.config/shell"
  "/home/Strange/.config/vim"
  "/home/Strange/.config/waybar"
  "/home/Strange/.config/yay"
  "/home/Strange/.config/qt5ct"
  "/home/Strange/.config/QtProject.conf"
  "/home/Strange/.config/fontconfig"
  #"/home/Strange/.local/share/fonts"

  "/etc/fstab"
  "/etc/mkinitcpio.conf"
  "/etc/default/grub"
  "/etc/locale.gen"
  "/etc/locale.conf"
  "/etc/hostname"
  "/etc/vconsole.conf"
  "/etc/crypttab"
  "/boot/grub/grub.cfg"
  "/lib/systemd/system-sleep/sway-resume"
)

for path in "${paths[@]}"; do
  name=$(basename "$path")
  tarball="$BACKUP_DIR/${name}_$(date +%Y%m%d_%H%M%S).tar.gz"
  if [ ! -e "$path" ]; then
    echo "ERROR: Required path does not exist: $path" >&2
    exit 1
  fi
  tar -czf "$tarball" "$path" || rm -f "$tarball"
done



