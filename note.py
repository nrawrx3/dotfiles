#!/usr/bin/python

import argparse
import os

filename = os.path.join(os.getenv('HOME'), 'dotfiles/note.txt')

notes = None
modified = False


with open(filename, 'r') as f:
    notes = f.read().strip().split('\n')
    a = argparse.ArgumentParser()
    a.add_argument('-r', '--remove', metavar='NOTE_NUMBER', type=int, default=0xffffffff, help='The note to remove')
    a.add_argument('-a', '--append', metavar='NOTE', type=str, default='', help='The note to append')
    a.add_argument('-p', '--prepend', metavar='NOTE', type=str, default='', help='The note to prepend')
    a.add_argument('-d', '--down', metavar=('NOTE_NUMBER', 'PLACES'), default=(0xffffffff, 0xffffffff), nargs=2, help='Push note down')
    a.add_argument('-u', '--up', metavar=('NOTE_NUMBER', 'PLACES'), default=(0xffffffff, 0xffffffff), nargs=2, help='Push note up')

    a = a.parse_args()
    if a.remove != 0xffffffff:
        r = a.remove
        if r < 0:
            r = len(notes) + r
        notes = [notes[i] for i in range(0, r)] + [notes[i] for i in range(r + 1, len(notes))]
        modified = True
    if a.append != '':
        notes.append(a.append)
        modified = True

    if a.prepend != '':
        notes = [a.prepend] + notes
        modified = True

    n, d = int(a.down[0]), int(a.down[1])
    if d != 0xffffffff:
        for i in range(n, n + d + 1):
            if i == len(notes) - 1:
                break
            notes[i], notes[i + 1] = notes[i + 1], notes[i]
        modified = True

    n, d = int(a.up[0]), int(a.up[1])
    if d != 0xffffffff:
        for i in range(n, n - d - 1, -1):
            if i == 0:
                break
            notes[i], notes[i - 1] = notes[i - 1], notes[i]
        modified = True

if modified:
    with open(filename, 'w') as f:
        f.write('\n'.join(notes).strip())

with open(filename, 'r') as f:
    print('-> ', end='')
    print("\n-> ".join(f.read().split('\n')))
