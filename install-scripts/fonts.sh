#!/bin/bash

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
WARN="$(tput setaf 5)[WARN]$(tput sgr0)"
RESET=$(tput sgr0)

# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_fonts.log"

fonts_packages=(
  ttf-liberation
  ttf-dejavu
  noto-fonts
  noto-fonts-emoji
  noto-fonts-cjk
  ttf-jetbrains-mono 
  ttf-jetbrains-mono-nerd 
  ttf-ubuntu-font-family
)

fonts_packages_yay=(
  ttf-ms-fonts
)


# Installation of main components
printf "\n%s - Installing fonts .... \n" "${NOTE}"

for FONT in "${fonts_packages[@]}"; do
  install_package_pacman "$FONT" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $FONT Package installation failed, Please check the installation logs"
    exit 1
  fi
done

for FONT_YAY in "${fonts_packages_yay[@]}"; do
  install_package "$FONT_YAY" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $FONT_YAY Package installation failed, Please check the installation logs"
    exit 1
  fi
done

echo
