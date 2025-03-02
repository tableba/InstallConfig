#!/bin/bash

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
WARN="$(tput setaf 5)[WARN]$(tput sgr0)"
RESET=$(tput sgr0)

pipewire=(
    pipewire
    wireplumber
    pipewire-audio
    pipewire-alsa
    pipewire-pulse
    sof-firmware
)

pipewire_yay=(
	pwvucontrol
)

# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_pipewire.log"


# Pipewire
printf "${NOTE} Installing Pipewire Packages...\n"
for PIPEWIRE in "${pipewire[@]}"; do
    install_package_pacman "$PIPEWIRE" 2>&1 | tee -a "$LOG"
    [ $? -ne 0 ] && { echo -e "\e[1A\e[K${ERROR} - $PIPEWIRE Package installation failed, Please check the installation logs"; exit 1; }
done

for PIPEWIRE_YAY in "${pipewire_yay[@]}"; do
    install_package "$PIPEWIRE_YAY" 2>&1 | tee -a "$LOG"
    [ $? -ne 0 ] && { echo -e "\e[1A\e[K${ERROR} - $PIPEWIRE_YAY Package installation failed, Please check the installation logs"; exit 1; }
done

printf "Activating Pipewire Services...\n"
systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service &>> "$LOG"
if [ $? -eq 1 ]; then
  echo "${ERROR} enabling pipewire services (please check $LOG)"
fi
systemctl --user enable --now pipewire.service &>> "$LOG"
if [ $? -eq 1 ]; then
  echo "${ERROR} enabling pipewire services (please check $LOG)"
fi

echo
