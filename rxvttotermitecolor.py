#!/usr/bin/python

FONT_NAME = "Pointfree 10"

s = """
[options]
scroll_on_output = false
scroll_on_keystroke = true
audible_bell = false
mouse_autohide = false
allow_bold = true
dynamic_title = true
urgent_on_bell = true
clickable_url = true
font = {}
scrollback_lines = 10000
search_wrap = true
#icon_name = terminal
geometry = 720x480

# "system", "on" or "off"
cursor_blink = off

# "block", "underline" or "ibeam"
cursor_shape = block

# $BROWSER is used by default if set, with xdg-open as a fallback
browser = firefox

# set size hints for the window
#size_hints = false

# emit escape sequences for other keys modified by Control
#modify_other_keys = false

[colors]
"""

import re
import sys

r = re.compile("(urxvt)?(.|\*)(background|foreground|color[0-9][0-9]?).*:.*#(......)")

assert len(sys.argv) >= 2
f = open(sys.argv[1], 'r')

if len(sys.argv) == 3:
    FONT_NAME = sys.argv[2]

s = s.format(FONT_NAME)

print(s)

for line in f:
    for m in re.finditer(r, line):
        print("{} = #{}".format(m.group(3), m.group(4)))

