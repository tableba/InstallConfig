#!/bin/bash

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 5)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
WHITE=$(tput setaf 7)
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

INSTALL_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_DIR=$INSTALL_DIR/install-scripts

# Create Directory for Install Logs
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi

echo "$(tput bold) *** Welcome to this Hyprland & co installation script! *** $ORANGE"
echo "This script assumes that you already have all of these:"
echo "-You followed the arch installation wiki"
echo "-You have a bootloader and it is configured"
echo "-You have a nvidia drivers if you have an nvidia card"

# Run the package check script
echo -e "\n$NOTE Checking system requirements..."
chmod +x "$SCRIPT_DIR/check_packages.sh"
"$SCRIPT_DIR/check_packages.sh"

read -p "Are you sure you want to continue? (y/n): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] || $confirm == [] ]] || exit 1

chmod +x "$SCRIPT_DIR/hyprland.sh"
"$SCRIPT_DIR/hyprland.sh"

chmod +x "$SCRIPT_DIR/pipewire.sh"
"$SCRIPT_DIR/pipewire.sh"

chmod +x "$SCRIPT_DIR/fonts.sh"
"$SCRIPT_DIR/fonts.sh"

#dotfiles

echo "$NOTE package installation is complete."

chmod +x "$SCRIPT_DIR/dotfiles.sh"
"$SCRIPT_DIR/dotfiles.sh"

