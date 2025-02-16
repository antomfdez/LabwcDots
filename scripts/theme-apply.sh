#!/bin/bash

THEMES_DIR="$HOME/.config/labwc-themes"

list_themes() {
    echo "Available themes:"
    if [ -d "$THEMES_DIR" ]; then
        ls -1 "$THEMES_DIR" | sed 's/^/• /'
    else
        echo "No themes directory found at $THEMES_DIR"
    fi
}

# Handle list option
if [ "$1" = "-l" ]; then
    list_themes
    exit 0
fi

# Verify theme name argument
if [ $# -eq 0 ]; then
    echo "Error: You must specify a theme name"
    echo "Usage: $0 [-l|theme-name]"
    echo "  -l      List available themes"
    echo "  theme   Apply specified theme"
    exit 1
fi

THEME_NAME="$1"
THEME_DIR="$THEMES_DIR/$THEME_NAME"
SET_SCRIPT="$THEME_DIR/set.sh"

# Verify theme directory exists
if [ ! -d "$THEME_DIR" ]; then
    echo "Error: Theme '$THEME_NAME' not found in $THEMES_DIR"
    echo "Use '-l' to list available themes"
    exit 1
fi

# Verify set.sh exists
if [ ! -f "$SET_SCRIPT" ]; then
    echo "Error: set.sh not found in '$THEME_NAME' theme directory"
    exit 1
fi

# Make script executable if needed
if [ ! -x "$SET_SCRIPT" ]; then
    chmod +x "$SET_SCRIPT" || {
        echo "Error: Failed to make set.sh executable"
        exit 1
    }
fi

# Apply the theme
echo "Applying theme: $THEME_NAME"
"$SET_SCRIPT"
