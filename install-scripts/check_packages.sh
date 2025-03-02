#!/bin/bash

# Colors for output
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
WARN="$(tput setaf 5)[WARN]$(tput sgr0)"
RESET=$(tput sgr0)

packages=(
    base
    linux
    linux-firmware
    vim
    sudo
    git
    man-db
    man-pages
    texinfo
    openssh
    rsync
)

# Function to check if a package is installed
check_package() {
    local package=$1
    if pacman -Q "$package" &>/dev/null; then
        echo -e "$OK $package is installed."
    else
        echo -e "$ERROR $package is not installed. Please install it with: sudo pacman -S $package"
        return 1
    fi
}

# Main function to check all required packages
check_packages() {
    local missing=false

    echo -e "\nChecking required packages..."

    check_package git || missing=true
    check_package linux-firmware || missing=true

    # CPU microcode check
    if grep -q "Intel" /proc/cpuinfo; then
        check_package intel-ucode || missing=true
    elif grep -q "AMD" /proc/cpuinfo; then
        check_package amd-ucode || missing=true
    else
        echo -e "$WARN Unable to determine CPU vendor. Please ensure microcode is installed manually."
    fi

    # Check if base-devel is installed
    if ! pacman -Q base-devel &> /dev/null; then
        echo "$NOTE Install base-devel.........."

        if sudo pacman -S --noconfirm --needed base-devel; then
            echo "$OK base-devel has been installed successfully."
        else
            echo "$ERROR base-devel not found nor cannot be installed."
            echo "$ACTION Please install base-devel manually before running this script... Exiting"
            exit 1
        fi
    fi

    # Check for each package listed above
    for package in "${packages[@]}"; do
      check_package "$package" || missing=true
    done

    if [ "$missing" = true ]; then
        echo -e "\n$ERROR One or more required packages are missing."
        exit 1
    else
        echo -e "\n$OK All required packages are installed."
    fi
}

# Call the function when the script is run
check_packages
