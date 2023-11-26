#!/usr/bin/env bash
set -euo pipefail

BKND_C='#c50ed220'
BORDER_C="#6e44deff"

# Use slurp to get an area of the screen from the user
REGION=$(slurp -d -b "$BKND_C" -c "$BORDER_C" 2>/dev/null || true)

# Find a file path that includes the date and time and is not currently taken
DIR_PATH="$HOME/Pictures/Screenshots"
DATETIME=$(date '+%Y%m%d-%H%M')
SS_PATH="$DIR_PATH/ss-$DATETIME.png"
I=1
while test -e "$SS_PATH"; do
  SS_PATH="$DIR_PATH/ss-$DATETIME-$I.png"
  I=$((I+1))
done

# Take the screenshot
if test -z "$REGION"; then
  grim "$SS_PATH"
else
  grim -g "${REGION-}" "$SS_PATH"
fi

# Print the file path to stderr
echo $SS_PATH >&2

# Open the screenshot in an image viewer
# eog -n "$SS_PATH"
