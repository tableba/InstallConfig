#!/bin/bash

# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_hyprland.log"

hyprland_packages=(
	hyprland
	waybar
	kitty
	dunst
	xdg-desktop-portal-hyprland
	hyprpolkitagent
	qt5-wayland
	qt6-wayland
	hyprpaper
	rofi-wayland
	cliphist
	dolphin
)

hyprland_packages_yay=(
  hyprshot
)


# Installation of main components
printf "\n%s - Installing Hyprland packages.... \n" "${NOTE}"

for HYPRLAND in "${hyprland_packages[@]}"; do
  install_package_pacman "$HYPRLAND" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $HYPRLAND Package installation failed, Please check the installation logs"
    exit 1
  fi
done

for HYPRLAND_YAY in "${hyprland_packages_yay[@]}"; do
  install_package "$HYPRLAND_YAY" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $HYPRLAND_YAY Package installation failed, Please check the installation logs"
    exit 1
  fi
done

echo
