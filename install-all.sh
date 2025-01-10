#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error and exit immediately

# Function to print messages
log() {
  echo -e "\033[1;32m[INFO]\033[0m $1"
}

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root." >&2
  exit 1
fi

log "Updating system and installing base-devel and git..."
pacman -S --needed --noconfirm base-devel git

# Clone and install Yay
if ! command -v yay &> /dev/null; then
  log "Installing Yay AUR helper..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  pushd /tmp/yay
  sudo -u "$SUDO_USER" makepkg -si --noconfirm
  popd
  rm -rf /tmp/yay
else
  log "Yay is already installed. Skipping..."
fi

# Install dependencies from deps file
if [[ -f deps ]]; then
  log "Installing dependencies from 'deps' file..."
  xargs -a deps -r -- pacman -S --needed --noconfirm
else
  log "No 'deps' file found. Skipping..."
fi

# Install AUR dependencies from yay-deps file
if [[ -f yay-deps ]]; then
  log "Installing AUR dependencies from 'yay-deps' file..."
  sudo -u "$SUDO_USER" xargs -a yay-deps -r -- yay -S --needed --noconfirm
else
  log "No 'yay-deps' file found. Skipping..."
fi

# Execute paste-dots.sh if it exists and is executable
if [[ -x paste-dots.sh ]]; then
  log "Executing 'paste-dots.sh'..."
  sudo -u "$SUDO_USER" ./paste-dots.sh
else
  log "'paste-dots.sh' not found or not executable. Skipping..."
fi

log "Installation complete!"
