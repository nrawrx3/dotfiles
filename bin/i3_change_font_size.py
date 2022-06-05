import os
import re
from pathlib import Path
from sys import argv


config_file = Path(os.getenv('HOME')) / '.config' / 'i3' / 'config'
regex = re.compile(r'(\s*font pango:\s+.+\s+)([0-9]+)\s*$')

def replace_fn(m):
    result = f'{m.group(1)}{new_size}'
    return result



def find_and_substitute(f):
    new_lines = [
            re.sub(regex, replace_fn, line).rstrip()
            for line in f
    ]
    return '\n'.join(new_lines)


if __name__ == '__main__':
    global new_size

    if len(argv) != 2:
        print(f'{argv[0]} <font-size>')
        exit(1)

    new_size = int(argv[1])

    with open(config_file) as f:
        new_string = find_and_substitute(f)
        print(new_string)

    with open(config_file, 'w') as f:
        f.write(new_string)

