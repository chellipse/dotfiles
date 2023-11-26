#!/usr/bin/env bash
set -euo pipefail

BKND_C='#c50ed220'
BORDER_C="#6e44deff"

# Use slurp to get an area of the screen from the user
REGION=$(slurp -d -b "$BKND_C" -c "$BORDER_C" 2>/dev/null || true)

if test -z "$REGION"; then
  grim - | wl-copy
else
  grim -g "${REGION-}" - | wl-copy
fi

