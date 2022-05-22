#!/bin/sh

setxkbmap -layout us -option ctrl:nocaps
xset r rate 200 40
xinput --set-prop "Glorious Model O" "libinput Accel Speed" -0.5

