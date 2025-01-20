#!/bin/bash


# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 5)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

LOG="install-$(date +%d-%H%M%S)_yay.log"

# Check Existing yay
if [ -d yay ]; then
    rm -rf yay 2>&1 | tee -a "$LOG"
fi

# Check for AUR helper and install if not found
ISAUR=$(command -v yay)
if [ -n "$ISAUR" ]; then
  printf "\n%s - AUR helper already installed, moving on.\n" "${OK}"
else
  printf "\n%s - AUR helper was NOT located\n" "$WARN"
  printf "\n%s - Installing yay from AUR\n" "${NOTE}"
  git clone https://aur.archlinux.org/yay.git || { printf "%s - Failed to clone yay from AUR\n" "${ERROR}"; exit 1; }
  cd yay || { printf "%s - Failed to enter yay directory\n" "${ERROR}"; exit 1; }
  makepkg -si --noconfirm 2>&1 | tee -a "$LOG" || { printf "%s - Failed to install yay from AUR\n" "${ERROR}"; exit 1; }

  # moving install logs in to Install-Logs folder
  mv install*.log ../Install-Logs/ || true   
  cd ..
fi

# Update system before proceeding
printf "\n%s - Performing a full system update to avoid issues.... \n" "${NOTE}"
ISAUR=$(command -v yay)

$ISAUR -Syu --noconfirm 2>&1 | tee -a "$LOG" || { printf "%s - Failed to update system\n" "${ERROR}"; exit 1; }

