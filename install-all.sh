#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error and exit immediately

# Get user's home directory
USER_HOME=$(eval echo ~"$SUDO_USER")

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
  sudo -u "$SUDO_USER" git clone https://aur.archlinux.org/yay.git /tmp/yay
  pushd /tmp/yay >/dev/null
  sudo -u "$SUDO_USER" makepkg -si --noconfirm
  popd >/dev/null
  rm -rf /tmp/yay
else
  log "Yay is already installed. Skipping..."
fi

# Clone GTK theme and icon theme
THEME_PATH="$USER_HOME/.themes/Material-Black-Cherry"
ICON_PATH="$USER_HOME/.local/share/icons/WhiteSur-red-dark"
if [[ ! -d "$THEME_PATH" ]]; then
  log "Installing GTK theme..."
  sudo -u "$SUDO_USER" mkdir -p "$USER_HOME/.themes"
  sudo -u "$SUDO_USER" git clone https://github.com/rtlewis1/GTK.git /tmp/gtk
  pushd /tmp/gtk >/dev/null
  sudo -u "$SUDO_USER" cp -r "Material-Black-Cherry" "$USER_HOME/.themes/"
  popd >/dev/null
  rm -rf /tmp/gtk
else
  log "GTK theme Material-Black-Cherry already installed. Skipping..."
fi

if [[ ! -d "$ICON_PATH" ]]; then
  log "Installing ICON theme..."
  sudo -u "$SUDO_USER" git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git /tmp/iconws
  pushd /tmp/iconws >/dev/null
  sudo -u "$SUDO_USER" ./install.sh -t red -a
  popd >/dev/null
  rm -rf /tmp/iconws
else
  log "ICON theme WhiteSur-red-dark already installed. Skipping..."
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
