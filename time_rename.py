# Prefixes files with letters so that they get ordered by a lexicographically(phew!) sorting
# file manager, or lister (ls), etc. etc. Most file managers _don't_ use lexi-order though.
# But ls does. The names are prefixed so that the files are ordered by time of change.

import os
import subprocess as sp
import sys
from collections import OrderedDict
from pprint import pprint

def base26(n):
    digits = []
    while True :
        q = n // 26
        r = n % 26
        digits.append(chr(65 + r))
        n = q
        if n == 0:
            break
    return ''.join(digits)

def doit(d):
    files = [os.path.join(d, f) for f in os.listdir(d)]
    times = dict((os.path.getctime(f), [f, '']) for f in files)
    times = OrderedDict(sorted(times.items()))
    prefixes = [base26(i) for i in range(0, len(files))]
    prefixes.sort()
    pprint(times)
    pprint(prefixes)
    i = 0
    for t, f in times.items():
        f[1] = os.path.join(d, prefixes[i] + '-' + os.path.basename(f[0]))
        i += 1

    for t, f in times.items():
        sp.call(['mv', f[0], f[1]])


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print('Usage: python3 {} <directory-path>'.format(sys.argv[0]))
        sys.exit(1)

    doit(sys.argv[1])
