#!/bin/bash
# full-backup.sh

echo "Backing up listed files"
sudo bash "$HOME/.config/shell/scripts/my_scripts/backup/base_backup.sh"

echo "Backing up pacman data"
sudo bash "$HOME/.config/shell/scripts/my_scripts/backup/pacman_backup.sh"

