# Bestest build tool evar. Cmake, make, rake, cake, lake,... nothing comes close.

import subprocess as sp
import os
import sys
import argparse

# Put files here
files = ['wallpaper.cpp']

# Default path to compiler
cc = 'g++'

cwd = os.getcwd()

command_line_cflags = ['-std=c++17']

def pkgconfig(libname, extra_args):
    out = sp.Popen(['pkg-config', libname] + extra_args, stdout=sp.PIPE)
    out, errs = out.communicate()
    if errs is not None:
        raise ValueError('Command failed with error -', errs)
    out = out.decode('utf-8')
    return out.strip().split(' ')


def run_gcc():
    # Call pkgconfig or put libflags here (as a list)

    sdl_flags = []

    lflags = ['-lstdc++fs']

    include_path = '-I' + str(os.path.dirname(os.path.abspath(__file__)))

    # Append lists here
    all_flags = [cc, include_path] + command_line_cflags + sdl_flags + files + lflags

    print('Build line = ', ' '.join(all_flags))
    sp.run(all_flags, check=True)


def arg_list(strlist: str):
    s = strlist.strip()
    assert(len(s) >= 2)
    assert(s[0] == '[')
    assert(s[-1] == ']')
    s = s[1:-1]
    libnames = [name.strip() for name in s.split(',')]
    return libnames


if __name__ == '__main__':
    a = argparse.ArgumentParser(usage='Shove .cpp files to gcc')

    # Example - ./build.py ,-ggdb,-Wall,-Wextra
    a.add_argument('cflags', nargs='?', default='', help="sequence of ',' and option. Options sent to gcc.")
    a.add_argument('-f', '--files', nargs='?', default='', help="Override the list of files. Sequence of ',' and filename")
    a.add_argument('-c', '--cc', nargs='?', default='g++', help="Override path to compiler")

    args = a.parse_args()

    command_line_cflags.extend(arg_list(args.cflags))

    if args.files != '':
        files = args.files.split(',')[1:]

    if args.cc != 'g++':
        cc = args.cc

    print(command_line_cflags)

    run_gcc()
