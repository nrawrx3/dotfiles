#!/usr/bin/env python

# Requires the ddcutil command. Install from AUR if on arch linux.
# Instructions on the command and the i2c_dev module:
# https://blog.woefe.com/posts/ddc_screen_brightness.html
#
#
# Load the i2c-dev kernel module with modprobe i2c-dev. To make this change persistent across reboots: echo i2c_dev >> /etc/modules-load.d/ddc.conf
# Create group i2c: groupadd i2c
# Create udev rules to allow group i2c read and write access to /dev/i2c-*: cp /usr/share/ddcutil/data/45-ddcutil-i2c.rules /etc/udev/rules.d/
# Add your user to the i2c group: usermod $USER -aG i2c

import re
import subprocess as sp
import argparse

# Just so I don't set my screen to 0 brightness
MIN_BRIGHTNESS = 10


def clamp(v, lo, hi):
    lo = max(lo, MIN_BRIGHTNESS)
    return min(max(v, lo), hi)


def set_brightness(brightness, display):
    command = 'ddcutil setvcp 10 {} --display {}'.format(brightness, display).split(' ')
    print(' '.join(command))
    sp.run(command)


getvcp_regex = re.compile(r'current value\s*=\s*([0-9]+)')


def get_current_brightness(display):
    command = 'ddcutil getvcp 10 --display {}'.format(display).split(' ')
    completed = sp.run(command, text=True, stdout=sp.PIPE, stderr=sp.PIPE)
    if completed.stderr == '' or completed.stderr is None:
        print('{}\n{}'.format(' '.join(command), completed.stdout))
        print('stdout =', completed.stdout)
        m = re.search(getvcp_regex, completed.stdout)
        if not m:
            print('Could not get brightness - Unexpected output from ddcutil')
            exit(1)

        brightness = int(m.group(1))
        print('Current brightness =', brightness)
        return brightness

    print(completed.stderr)
    exit(1)


if __name__ == '__main__':
    ap = argparse.ArgumentParser(
        description='Set brightness of monitor using the ddcutil command'
    )

    ap.add_argument('brightness', type=int, help='brightness percent (integer)')
    ap.add_argument('--display', '-d', default=1, type=int, help='display number')
    ap.add_argument(
        '--add',
        '-a',
        default=False,
        action='store_true',
        help='add to current brightness',
    )

    ap.add_argument(
        '--sub',
        '-s',
        default=False,
        action='store_true',
        help='subtract from current brightness',
    )

    args = ap.parse_args()
    if args.add:
        current_brightness = get_current_brightness(args.display)
        brightness = clamp(current_brightness + args.brightness, 0, 100)
    elif args.sub:
        current_brightness = get_current_brightness(args.display)
        brightness = clamp(current_brightness - args.brightness, 0, 100)
    else:
        brightness = clamp(args.brightness, 0, 100)

    set_brightness(brightness, args.display)
