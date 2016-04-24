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

if modified:
    with open(filename, 'w') as f:
        f.write('\n'.join(notes).strip())

with open(filename, 'r') as f:
    print(f.read())
