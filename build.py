# Bestest build tool evar. Cmake, make, rake, cake, lake,... nothing comes close.

import subprocess as sp
import os

# Put files here
files = ['weekend.cpp']

def pkgconfig(libname, extra_args):
    out = sp.Popen(['pkg-config', libname] + extra_args, stdout=sp.PIPE)
    out, errs = out.communicate()
    if errs is not None:
        raise ValueError('Command failed with error -', errs)
    out = out.decode('utf-8')
    return out.strip().split(' ')


sdl_flags = pkgconfig('sdl2', ['--libs', '--cflags'])
include_path = '-I' + str(os.path.dirname(os.path.abspath(__file__)))

all_flags = ['g++', '-std=c++17', include_path] + sdl_flags + files

sp.run(all_flags, check=True)
