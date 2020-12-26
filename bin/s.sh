#!/bin/sh

xset r rate 250 40 &
setxkbmap -layout us -option ctrl:nocaps &
chromium &
slack &
discord &
subl3 &
