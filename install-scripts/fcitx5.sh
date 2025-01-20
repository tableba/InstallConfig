#!/bin/bash

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
WARN="$(tput setaf 5)[WARN]$(tput sgr0)"
RESET=$(tput sgr0)
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
YELLOW=$(tput setaf 3)

# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_fcitx5.log"

fcitx5_package=(
  fcitx5
  fcitx5-configtool
  fcitx5-mozc-ut
  fcitx5-qt
  mozc
)

for FCITX5 in "${fcitx5_package[@]}"; do
  install_package_pacman "$FCITX5" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $FCITX5 Package installation failed, Please check the installation logs"
    exit 1
  fi
done

echo "$NOTE To activate a japanese keyboard or other, type$YELLOW fcitx5-configtool$RESET and select your preferred keyboard inputs"
echo

