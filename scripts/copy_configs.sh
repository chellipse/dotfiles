#!/bin/bash

# Check for input argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <destination_folder>"
    exit 1
fi

# HOME=
DEST="$1"

# Check if destination exists
if [ ! -d "$DEST" ]; then
    echo "Error: Destination folder $DEST does not exist."
    exit 1
fi

# List of files and directories to copy
FILES=(
    "/home/chell/.config/nvim/"
    "/home/chell/.bashrc"
    "/home/chell/.bash_aliases"
    "/home/chell/.config/i3/"
    "/home/chell/.config/i3status/"
    "/home/chell/.config/alacritty/"
    "/home/chell/.config/sway/"
    "/home/chell/.config/dunst/"
    "/home/chell/.config/i3status-rust/"
    "/home/chell/.config/kitty/"
    "/home/chell/.config/ranger/"
    "/home/chell/.config/zathura/"
    "/home/chell/.config/scripts/"
)

# Copy each file/folder to the destination
for file in "${FILES[@]}"; do
    if [ -e "$file" ]; then
        cp -r "$file" "$DEST"
        echo "Copied $file to $DEST"
    else
        echo "Warning: $file does not exist. Skipping."
    fi
done

echo "All files/folders copied to $DEST!"
