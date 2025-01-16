#!/bin/bash
# Global Functions for Scripts #

set -e

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 5)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)


# Function for installing packages
install_package_pacman() {
  # Checking if package is already installed
  if pacman -Q "$1" &>/dev/null ; then
    echo -e "${OK} $1 is already installed. Skipping..."
  else
    # Package not installed
    echo -e "${NOTE} Installing $1 ..."
    sudo pacman -S --noconfirm "$1" &>> "$LOG"
    # Making sure package is installed
    if pacman -Q "$1" &>/dev/null ; then
      echo -e "\e[1A\e[K${OK} Package ${YELLOW}$1${RESET} has been successfully installed!"
    else
      # Something is missing, exiting to review log
      echo -e "${ERROR} $1 failed to install. You may need to install manually (Check $LOG)."
      exit 1
    fi
  fi
}


# Function for installing packages
install_package() {
  # Checking if package is already installed
  if yay -Q "$1" &>> /dev/null ; then
    echo -e "${OK} $1 is already installed. Skipping..."
  else
    # Package not installed
    echo -e "${NOTE} Installing $1 ..."
    yay -S --noconfirm "$1" &>> "$LOG"
    # Making sure package is installed
    if yay -Q "$1" &>> /dev/null ; then
      echo -e "\e[1A\e[K${OK} Package ${YELLOW}$1${RESET} has been successfully installed!"
    else
      # Something is missing, exiting to review log
      echo -e "${ERROR} $1 failed to install. You may need to install manually (Check $LOG)."
      exit 1
    fi
  fi
}

# Function for uninstalling packages
uninstall_package() {
  local pkg="$1"

  # Checking if package is installed
  if pacman -Qi "$pkg" &>> /dev/null ; then
    # Package is installed
    echo -e "${NOTE} Uninstalling $pkg ..."
    sudo pacman -R --noconfirm "$pkg" &>/dev/null
    # Check if the package was uninstalled
    if ! pacman -Qi "$pkg" &>> "$LOG" ; then
      echo -e "\e[1A\e[K${OK} $pkg was uninstalled."
    else
      echo -e "\e[1A\e[K${ERROR} $pkg failed to uninstall."
      return 1 
    fi
  else
    echo -e "${NOTE} $pkg is not installed, skipping uninstallation."
  fi
  return 0 
}
