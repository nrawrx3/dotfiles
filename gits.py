#!/usr/bin/python

import subprocess as sp
import os
import sys
import argparse as ap

NAME_TO_URL = {
    'llvm': "https://github.com/llvm-mirror/llvm.git",
    'clang': "https://github.com/llvm-mirror/clang.git",
    'libjit': "git://git.savannah.gnu.org/libjit.git",
    'libbsd': "git://anongit.freedesktop.org/git/libbsd",
    'luajit-2.0': "http://luajit.org/git/luajit-2.0.git",
    'toml': "https://github.com/toml-lang/toml.git",
    'cpython': "https://github.com/python/cpython",
    'gpm': "https://github.com/pote/gpm.git",
    'earnestly': "https://github.com/Earnestly/pkgbuilds.git",
    'scaffold': "https://snyp@bitbucket.org/snyp/scaffold.git",
    'regvm': "https://snyp@bitbucket.org/snyp/regvm.git",
    'musl': "git://git.musl-libc.org/musl",
    'llvm-clang-samples': "https://github.com/eliben/llvm-clang-samples.git",
    'llvm-leg': "https://github.com/codeplaysoftware/llvm-leg",
    'clang-leg': "https://github.com/codeplaysoftware/clang-leg",
    'xdot.py': "https://github.com/jrfonseca/xdot.py",
    "dotfiles": "https://snyp@bitbucket.org/snyp/dotfiles.git",
    "CppCoreGuidelines": "http://github.com/isocpp/CppCoreGuidelines.git",
    "cpp-netlib": "https://github.com/cpp-netlib/cpp-netlib.git",
    "benchmark": "https://github.com/google/benchmark.git"
}

HSB = os.getenv('HSB')

GITS = 'gits'
HSB_GITS_DIR = os.path.join(HSB, GITS)
HOME_GITS = os.path.join(os.getenv('HOME'), GITS)

CUR_DIR = os.getcwd()

def cd(dir_name):
    os.chdir(dir_name)


def clone_all_in_hsb():
    cd(HSB_GITS_DIR)
    for dir_name in os.listdir(HOME_GITS):
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
    for dir_name in os.listdir(HOME_GITS):
        if not (dir_name in NAME_TO_URL):
            print(sys.argv[0], "Url for {} not in the dict - not pulling".format(dir_name))
            continue
        try:
            cd(os.path.join(HSB_GITS_DIR, dir_name))
            sp.run(['git', 'pull', 'hdd', 'master'], check=True)

        except sp.CalledProcessError as e:
            print("{} - Git failed: {}".format(sys.argv[0], e.stderr))
            cd(CUR_DIR)
            sys.exit(-1)

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
    if not dir_name in dir_list:
        that_dir = os.path.join(HSB_GITS_DIR, dir_name)
        cd(HOME_GITS)
        sp.run(['git', 'clone', that_dir])
        cd(dir_name)
        sp.run(['git', 'remote', 'set-url', 'origin', NAME_TO_URL[dir_name]])
        sp.run(['git', 'remote', 'add', 'hsb', that_dir])
    else:
        cd(HOME_GITS)
        sp.run(['git', 'pull', 'hsb', 'master'])
    cd(CUR_DIR)

if __name__ == '__main__':
    a = ap.ArgumentParser(usage='Easily backup the git projects')
    a.add_argument('--clone_one', type=str, default='', help='The directory to clone')
    a.add_argument('--clone_all', action='store_true', help='Clone all directories')
    a.add_argument('--pull_one', type=str, default='', help='Pull changes from home directory')
    a.add_argument('--pull_all', action='store_true', help='Pull all directories')
    a.add_argument('--clone_from', type=str, default='', help='Clone or pull a directory from hsb')
    a.add_argument('--hsb_gits_dir', type=str, default=HSB_GITS_DIR, help='HSB directory')

    a = a.parse_args()

    if a.hsb_gits_dir != HSB_GITS_DIR:
        HSB_GITS_DIR = a.hsb_gits_dir

    if a.clone_all:
        clone_all_in_hsb()

    if a.pull_all:
        pull_all_in_hsb()

    if a.clone_one != '':
        clone_one_in_hsb(a.clone_one)

    if a.pull_one != '':
        pull_one_in_hsb(a.pull_one)

    if a.clone_from != '':
        clone_or_pull_from_hsb(a.clone_from)

