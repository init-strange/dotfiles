#!/bin/bash
# backup_pacman_data.sh
set -e

BACKUP_DIR="/home/Strange/Backup/pkg_lists"
mkdir -p "$BACKUP_DIR"

pacman -Qqe > "$BACKUP_DIR/pkglist_explicit.txt"
pacman -Qq  > "$BACKUP_DIR/pkglist_all.txt"
pacman -Qqm > "$BACKUP_DIR/pkglist_aur.txt" 2>/dev/null || true
