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

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_dotfiles.log"


# Installation of main components
printf "\n%s - Installing dotfiles .... \n" "${NOTE}"

git clone https://github.com/tableba/dotfile.git "$HOME/.fake_dotfiles" 
if [ $? -eq 1 ]; then
  echo "{$ERROR} couldn't clone the dotfiles repo (https://github.com/tableba/dotfiles.git), you have to install it manually. (check $LOG)"
fi

echo
