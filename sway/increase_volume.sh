#!/bin/bash

CUR_VOL=$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
if [ $CUR_VOL -lt 130 ]; then
    pactl set-sink-volume @DEFAULT_SINK@ +2%
fi

