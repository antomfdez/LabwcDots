#!/bin/bash

# Ensure an argument (wallpaper path) is provided
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/wallpaper"
    exit 1
fi

WALLPAPER_PATH="$1"

# Check if the file exists
if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "Error: File not found at $WALLPAPER_PATH"
    exit 1
fi

# Copy the wallpaper to ~/.labwc
LABWC_WALLPAPER_FILE="$HOME/.labwc"
cp "$WALLPAPER_PATH" "$LABWC_WALLPAPER_FILE"

# Set ~/.labwc as the wallpaper using swaybg
swaybg -i "$LABWC_WALLPAPER_FILE" -m fill >/dev/null 2>&1 & disown

echo "Wallpaper $WALLPAPER_PATH set :)"
