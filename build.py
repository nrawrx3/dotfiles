#!/usr/bin/env python

import subprocess as sp
import os
import sys
import argparse

# Put files here
# files = ['vis_buddy_alloc.cpp']
files = ['wallpaper.cpp']
# files = ['case_change.cpp']

this_dir = os.path.dirname(os.path.abspath(__file__))

# Default path to compiler
cc = 'clang++'

cwd = os.getcwd()

# ------ Linker flags, like lib directory
ldflags = []
if os.getenv('LDFLAGS'):
    ldflags.extend(os.getenv('LDFLAGS').split(' ')) # Assumes no spaces in pathname components

cflags = ['-std=c++17']
if os.getenv('CXXFLAGS'):
    cflags.extend(os.getenv('CXXFLAGS').split(' ')) # Assumes no spaces in pathname components

if os.getenv('CPPFLAGS'):
    cflags.extend(os.getenv('CPPFLAGS').split(' ')) # Assumes no spaces in pathname components

lflags = []

def init_lflags():
    if sys.platform == 'linux':
        # On Linux use libstdc++
        lflags.append('-lstdc++fs')
    elif sys.platform == 'darwin':
        # On Mac, make sure to use clang
        assert cc.find('clang') != -1
        lflags.append('-lc++fs')
    else:
        raise ValueError('Will not work on windows')


def pkgconfig(libname, extra_args):
    out = sp.Popen(['pkg-config', libname] + extra_args, stdout=sp.PIPE)
    out, errs = out.communicate()
    if errs is not None:
        raise ValueError('Command failed with error -', errs)
    out = out.decode('utf-8')
    return out.strip().split(' ')


def run_cc():
    # Call pkgconfig or put libflags here (as a list)

    cflags.extend(pkgconfig('sdl2', ['--cflags']))
    lflags.extend(pkgconfig('sdl2', ['--libs']))

    include_path = '-I' + this_dir

    # Append lists here
    all_flags = [cc, include_path] + cflags + files + ldflags + lflags

    print('Build line = ', ' '.join(all_flags))
    sp.run(all_flags, check=True)


def parse_options_list(list_as_string):
    if not list_as_string:
        return []

    assert len(list_as_string) >= 2
    list_as_string = list_as_string[1:-1]
    options = list_as_string.split(',')
    options = [o.strip() for o in options]
    return options


if __name__ == '__main__':
    a = argparse.ArgumentParser(usage='Shove .cpp files to gcc')

    # Example - ./build.py ,-ggdb,-Wall,-Wextra
    a.add_argument('cflags', nargs='?', default='', help="[options]")
    a.add_argument('-f', '--files', nargs='?', default='', help="[files]")
    a.add_argument('-c', '--cc', nargs='?', default='g++', help="Override path to compiler")

    args = a.parse_args()

    cflags.extend(parse_options_list(args.cflags))

    if args.files != '':
        files = parse_options_list(args.cflags)

    if args.cc != 'g++':
        cc = args.cc
    
    init_lflags()

    run_cc()
