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

if [ -d "$HOME/.dotfiles" ]; then
  cd "$HOME/.dotfiles" || exit 1
  echo "$ERROR $HOME/.dotfiles already exists, it is up to you to run the configure the dotfiles."
else
  if git clone https://github.com/tableba/dotfiles.git "$HOME/.dotfiles" 2>&1 | tee -a "$LOG"; then
    cd "$HOME/.dotfiles" || exit 1
    chmod +x install.sh
    ./install.sh
  else
    echo "$ERROR Couldn't clone the dotfiles repo (https://github.com/tableba/dotfiles.git), you may have to install it manually. (check $LOG)"
  fi
fi

cd "$PARENT_DIR" || exit 1

echo
