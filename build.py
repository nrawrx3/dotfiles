# Bestest build tool evar. Cmake, make, rake, cake, lake,... nothing comes close.

import subprocess as sp
import os
import argparse

# Put files here
files = ['weekend.cpp']

command_line_cflags = []

def pkgconfig(libname, extra_args):
    out = sp.Popen(['pkg-config', libname] + extra_args, stdout=sp.PIPE)
    out, errs = out.communicate()
    if errs is not None:
        raise ValueError('Command failed with error -', errs)
    out = out.decode('utf-8')
    return out.strip().split(' ')


def run_gcc():
    # Call pkgconfig or put libflags here (as a list)
    sdl_flags = pkgconfig('sdl2', ['--libs', '--cflags'])

    include_path = '-I' + str(os.path.dirname(os.path.abspath(__file__)))

    # Append lists here
    all_flags = ['g++', '-std=c++17', include_path] + command_line_cflags  + sdl_flags + files
    print('Build line = ', ' '.join(all_flags))
    sp.run(all_flags, check=True)


if __name__ == '__main__':
    a = argparse.ArgumentParser(usage='Shove .cpp files to gcc')

    # Example - ./build.py ,-ggdb,-Wall,-Wextra
    a.add_argument('cflags', default='', help="sequence of ',' and option. Options sent to gcc.")

    args = a.parse_args()

    for opt in args.cflags.split(','):
        if opt != '':
            command_line_cflags.append(opt)

    print(command_line_cflags)

    run_gcc()
