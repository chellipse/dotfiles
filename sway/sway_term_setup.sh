#!/bin/bash

# spawns T[H[_current-term_, kitty]H[kitty, kitty]]

# command variables
msg="swaymsg"
h="split h"
v="split v"
fp="focus parent"
tab="layout tabbed"
stack="layout stacking"
kitty="exec kitty"
delay="0.5"

# Execute the command with both variables
$msg $tab
$msg $h
$msg $kitty
sleep $delay
$msg $fp
$msg $kitty
sleep $delay
$msg $h
$msg $kitty
sleep $delay
