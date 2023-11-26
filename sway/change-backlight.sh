#!/usr/bin/env bash
set -euo pipefail
DIR="$(realpath "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )")"


base="/sys/class/backlight"
vendor="intel_backlight"
path="$base/$vendor"

if [ ! -d $path ]; then
	echo "$path does not exist, please adjust vendor"
fi

current=$(cat $path/actual_brightness)
max=$(cat $path/max_brightness)
current_p=$((current*100/max))
change="$1"
new_p=$((current_p+change))
echo $new_p
if (( $new_p > 100 )); then
    new_p=100
fi
if (( $new_p < 0 )); then
    new_p=1
fi
tee $path/brightness <<< $((new_p*max/100)) > /dev/null

"$DIR/level-display.sh" backlight 'echo $(($(cat '"$path/actual_brightness"')*100/$(cat '"$path/max_brightness"')))'
