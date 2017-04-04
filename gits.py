#!/usr/bin/env python3

# ~/.local/bin/gits.py
# --------------------

# Managing git repositories on my computer. Can't simply rsync these, so using
# git itself.

import subprocess as sp
import os
import sys
import argparse as ap
import pprint

NAME_TO_URL = {
    'llvm': 'https://github.com/llvm-mirror/llvm.git',
    'clang': 'https://github.com/llvm-mirror/clang.git',
    'libjit': 'git://git.savannah.gnu.org/libjit.git',
    'libbsd': 'git://anongit.freedesktop.org/git/libbsd',
    'luajit-2.0': 'http://luajit.org/git/luajit-2.0.git',
    'cpython': 'https://github.com/python/cpython',
    'earnestly': 'https://github.com/Earnestly/pkgbuilds.git',
    'scaffold': 'https://snyp@bitbucket.org/snyp/scaffold.git',
    'musl': 'git://git.musl-libc.org/musl',
    'llvm-clang-samples': 'https://github.com/eliben/llvm-clang-samples.git',
    'dotfiles': 'https://snyp@bitbucket.org/snyp/dotfiles.git',
    'CppCoreGuidelines': 'http://github.com/isocpp/CppCoreGuidelines.git',
    'benchmark': 'https://github.com/google/benchmark.git',
    'vim-plug': 'https://github.com/junegunn/vim-plug',
    'debugger.lua': 'https://github.com/slembcke/debugger.lua.git',
    'nanomsg': 'https://github.com/nanomsg/nanomsg.git',
    'YCM-Generator': 'https://github.com/rdnetto/YCM-Generator.git',
    'cxxopts': 'https://github.com/jarro2783/cxxopts.git',
    'qbe': 'git://c9x.me/qbe.git',
    'mbedtls': 'https://github.com/ARMmbed/mbedtls.git',
    'cmp': 'https://github.com/camgunz/cmp.git',
    'nflibs': 'https://github.com/niklasfrykholm/nflibs.git',
    'Vulkan-Hpp':'https://github.com/KhronosGroup/Vulkan-Hpp.git',
    'glad': 'https://github.com/Dav1dde/glad.git',
    'learnogl': 'https://bitbucket.com/snyp/learnogl',
    'ycmd': 'https://github.com/Valloric/ycmd',
    'stb': 'https://github.com/nothings/stb',
    'ogl-samples': 'https://github.com/g-truc/ogl-samples.git',
    'par': 'https://github.com/prideout/par.git',
    'docs.gl': 'https://github.com/BSVino/docs.gl.git'
}

HSB = os.getenv('HSB')

GITS = 'gits'
HSB_GITS_DIR = os.path.join(HSB, GITS)
HOME_GITS = os.path.join(os.getenv('HOME'), GITS)

CUR_DIR = os.getcwd()

def cd(dir_name):
    print("CD -", dir_name)
    os.chdir(dir_name)


def clone_all_in_hsb():
    cd(HSB_GITS_DIR)
    not_present = set(os.listdir(HOME_GITS)) - set(os.listdir(HSB_GITS_DIR))
    for dir_name in not_present:
        if not (dir_name in NAME_TO_URL):
            print(sys.argv[0], "Url for {} not in the dict - not cloning".format(dir_name))
            continue
        try:
            home_dir = os.path.join(HOME_GITS, dir_name)
            sp.run(['git', 'clone', home_dir], stdout=sp.PIPE, check=True)
            cd(dir_name)
            sp.run(['git', 'remote', 'set-url', 'origin', NAME_TO_URL[dir_name]], check=True)
            sp.run(['git', 'remote', 'add', 'hdd', home_dir], check=True)
            cd(HSB_GITS_DIR)

        except sp.CalledProcessError as e:
            print("{} - Git failed: {}".format(sys.argv[0], e.stderr))
            sys.exit(-1)

    cd(CUR_DIR)


def clone_one_in_hsb(dir_name):
    if not (dir_name in NAME_TO_URL):
        print('{} is not present in the dict, will not clone'.format(dir_name))
        return

    cd(HSB_GITS_DIR)
    home_dir = os.path.join(HOME_GITS, dir_name)
    sp.run(['git', 'clone', home_dir], stdout=sp.PIPE, check=True)
    cd(dir_name)
    sp.run(['git', 'remote', 'set-url', 'origin', NAME_TO_URL[dir_name]], check=True)
    sp.run(['git', 'remote', 'add', 'hdd', home_dir], check=True)
    cd(HSB_GITS_DIR)
    cd(CUR_DIR)


def pull_all_in_hsb():
    failed_list = []
    for dir_name in os.listdir(HOME_GITS):
        if not (dir_name in NAME_TO_URL):
            print(sys.argv[0], "Url for {} not in the dict - not pulling".format(dir_name))
            continue
        try:
            cd(os.path.join(HSB_GITS_DIR, dir_name))
            sp.run(['git', 'pull', 'hdd', 'master'], check=True)

        except sp.CalledProcessError as e:
            failed_list.append("{} - {} - Git failed: {}".format(dir_name, sys.argv[0], e.stderr))

    if len(failed_list) != 0:
        print("Some failed: ")
        pprint.pprint(failed_list)

    cd(CUR_DIR)


def pull_one_in_hsb(dir_name):
    if not (dir_name in NAME_TO_URL):
        print(sys.argv[0], "Url for {} not in the dict - not pulling".format(dir_name))
        return

    cd(os.path.join(HSB_GITS_DIR, dir_name))
    sp.run(['git', 'pull', 'hdd', 'master'], check=True)
    cd(CUR_DIR)

def clone_or_pull_from_hsb(dir_name):
    if not dir_name in NAME_TO_URL:
        print(sys.argv[0], "Not in dict, not checking")
    dir_list = os.listdir(HOME_GITS)
    print("Doing", dir_name)
    if not dir_name in dir_list:
        that_dir = os.path.join(HSB_GITS_DIR, dir_name)
        cd(HOME_GITS)
        print(['git', 'clone', that_dir])
        sp.run(['git', 'clone', that_dir])
        cd(dir_name)
        sp.run(['git', 'remote', 'set-url', 'origin', NAME_TO_URL[dir_name]])
        sp.run(['git', 'remote', 'add', 'hsb', that_dir])
    else:
        cd(os.path.join(HOME_GITS, dir_name))
        print(['git', 'pull', 'hsb', 'master'])
        sp.run(['git', 'pull', 'hsb', 'master'])
    cd(CUR_DIR)

def clone_or_pull_from_hsb_all():
    for dir_name in NAME_TO_URL:
        clone_or_pull_from_hsb(dir_name)

def remove_if_not_in_dict(dir_name):
    cd(HOME_GITS)
    dirs = os.listdir('.')
    if not dir_name in NAME_TO_URL:
        print('Removing', dir_name)
        #sp.run(['rm', '-r', '-f', dir_name])
    cd(CUR_DIR)

def clean():
    cd(HOME_GITS)
    dirs = os.listdir('.')
    hsb_dirs = None

    try:
        hsb_dirs = os.listdir(os.path.join(HSB_GITS_DIR))
    except:
        print('HSB not available, so not going to remove those')

    for dir_name in dirs:
        if dir_name in NAME_TO_URL:
            continue
        print('Removing: {}'.format(dir_name))
        sp.run(['rm', '-r', '-f', dir_name])
        if hsb_dirs is not None and dir_name in hsb_dirs:
            hsb_dir_name = os.path.join(HSB_GITS_DIR, dir_name)
            print('Removing: {}'.format(hsb_dir_name))
            sp.run(['rm', '-r', '-f', hsb_dir_name])
    cd(CUR_DIR)



def update_all():
    cd(HOME_GITS)
    for d in NAME_TO_URL:
        cd(d)
        sp.run(['git', 'pull', 'origin', 'master'])
        cd(HOME_GITS)

if __name__ == '__main__':
    a = ap.ArgumentParser(usage='Easily backup the git projects')
    a.add_argument('--update_all', action='store_true', help='Sync with master all the repositories')
    a.add_argument('--clone_one', type=str, default='', metavar='DIRECTORY', help='The directory to clone')
    a.add_argument('--clone_all', action='store_true', help='Clone all directories to hsb')
    a.add_argument('--pull_one', type=str, default='', metavar='DIRECTORY', help='Pull changes from home directory')
    a.add_argument('--pull_all', action='store_true',  help='Pull all noted directories')
    a.add_argument('--clone_or_pull_from', type=str, default='', metavar='DIRECTORY', help='Clone or pull a directory from hsb')
    a.add_argument('--clone_or_pull_from_all', action='store_true', help='Clone or pull all noted directories from hsb')
    a.add_argument('--hsb_gits_dir', type=str, default=HSB_GITS_DIR, help='HSB directory')
    a.add_argument('--remove_if_not_in_dict', type=str, default='', help='Remove the directory if not present in the note')
    a.add_argument('--clean', action='store_true', help='Remove directories no longer in the url list')

    a = a.parse_args()

    HSB_GITS_DIR = a.hsb_gits_dir

    if a.update_all:
        update_all()

    if a.clone_all:
        clone_all_in_hsb()

    if a.pull_all:
        pull_all_in_hsb()

    if a.clone_one != '':
        clone_one_in_hsb(a.clone_one)

    if a.pull_one != '':
        pull_one_in_hsb(a.pull_one)

    if a.clone_or_pull_from != '':
        clone_or_pull_from_hsb(a.clone_or_pull_from)

    if a.clone_or_pull_from_all:
        clone_or_pull_from_hsb_all()

    if a.remove_if_not_in_dict != '':
        remove_if_not_in_dict(a.remove_if_not_in_dict)

    if a.clean:
        clean()