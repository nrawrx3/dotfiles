#!/usr/bin/env python3

# Change some string in all files recursively in directories. Use with caution.
# Also optionally change _paths_. Case is not preserved. This could be a todo -
# CamelCase could be preserved.
# Example: namesubst.py $(pwd) -r john -n alice  -e "[go,py,mod]" --rename-files

import re
import argparse
import os
from pprint import pprint

ignored_subdirectories = [
    '.git',
    '.node_modules',
    '.vscode',
    '_build'
]

class Config:
    def __init__(self):
        self.extensions = []
        self.is_dry_run = True
        self.regex = None
        self.replace_with = None
        self.changed_files = []
        self.changed_paths = []
        self.do_change_paths = False
        self.do_subst_content = True
        self.ignore_substring = False

config = Config()

def rename_file(dirpath, filename, mode):
    new_filename = re.sub(config.regex, config.replace_with, filename)

    old_filepath = os.path.join(dirpath, filename)
    new_filepath = os.path.join(dirpath, new_filename)

    if config.ignore_substring in old_filepath:
        print(f'Ignoring path {old_filepath}')
        return

    if new_filename != filename:
        print(f'Renamed {mode} {old_filepath} to {new_filepath}')

    if not config.is_dry_run:
        os.rename(old_filepath, new_filepath)



def walk_directory(d):
    # Collecting the sub-directory paths so that we can change their names.
    # Don't want to rename directories while traversing using os.walk. (Don't
    # know the behavior and don't want to inquire either)
    subdirpaths = []
    dirpath_and_filenames = []

    for cur_root_dirpath, subdirnames, filenames in os.walk(d):
        root_dirname = os.path.basename(cur_root_dirpath)

        # If we're inside any directory matching one of the
        # ignored_subdirectories, don't delve.
        root_dir_split = cur_root_dirpath.split(os.sep)

        do_delve = True

        for dirname in root_dir_split:
            if dirname in ignored_subdirectories:
                do_delve = False
                break

        if not do_delve:
            continue

        if config.do_change_paths:
            for subdirname in subdirnames:
                if subdirname in ignored_subdirectories:
                    continue 
                subdirpaths.append((cur_root_dirpath, subdirname))

        for f in filenames:
            ext_ok = False
            for ext in config.extensions:
                if f.endswith(ext):
                    ext_ok = True
                    break

            if not ext_ok:
                continue

            filepath = os.path.join(cur_root_dirpath, f)

            if config.do_subst_content:
                replace_in_file(filepath)

            if config.do_change_paths:
                dirpath_and_filenames.append((cur_root_dirpath, f))

    # First rename all files
    for (dirpath, filename) in dirpath_and_filenames:
        rename_file(dirpath, filename, "filename")

    # Rename all subdirs. Sort such that the deeper sub-directories are renamed first.
    subdirpaths.sort(key=lambda p: -len(os.path.join(p[0], p[1])))
    for (dirpath, subdirname) in subdirpaths:
        rename_file(dirpath, subdirname, "dirname")


def replace_in_file(filepath):
    if config.ignore_substring in filepath:
        print(f'Ignoring contents in {filepath}')
        return

    # print('Replacing in file', filepath)
    with open(filepath, 'r') as stream:
        source = stream.read()
        new_string = re.sub(config.regex, config.replace_with, source)
        if new_string != source:
            write_to_file(filepath, new_string)


def write_to_file(filepath, new_string):
    config.changed_files.append(filepath)
    if config.is_dry_run:
        return
    print(new_string)
    with open(filepath, 'w') as stream:
        stream.write(new_string)

def arg_list(literal_python_list: str):
    s = literal_python_list.strip()
    assert(len(s) >= 2)
    assert(s[0] == '[')
    assert(s[-1] == ']')
    s = s[1:-1]
    libnames = [name.strip() for name in s.split(',')]
    return libnames

if __name__ == '__main__':
    ap = argparse.ArgumentParser(description='Change string in all text files recursively')
    ap.add_argument('directories', nargs='*', default=[], help='list of directories to traverse')
    ap.add_argument('-e', '--extensions', default='', help='list of extensions')
    ap.add_argument('-r', '--regex', default=None, help='regex to match string against')
    ap.add_argument('-n', '--newstring', default=None, help='new string')
    ap.add_argument('-y', '--yes', action='store_true', help='Yes, do actually modify the files instead of a dry run')
    ap.add_argument('-p', '--rename-files', action='store_true', default=False, help='change directory and file names also')
    ap.add_argument('-o', '--only-rename-files', action='store_true', default=False, help='change directory and file names only, not their contents')
    ap.add_argument('-i', '--ignore-substring', default='', help='ignore path if it contains given substring')

    args = ap.parse_args()
    print('Traversing directories - ' + str(args.directories))

    if args.extensions == '':
        print('Will test ALL files')
    else:
        config.extensions = arg_list(args.extensions)
        print('Replacing in files with extensions: ' + str(config.extensions))

    if args.rename_files:
        config.do_change_paths = True

    if args.only_rename_files:
        config.do_subst_content = False

    config.ignore_substring = args.ignore_substring

    config.is_dry_run = not args.yes
    if config.is_dry_run:
        print('DOING A DRY RUN\n')
    else:
        print('NOT A DRY RUN\n')

    if args.regex is None:
        print('Error - Need regex')
        exit()

    if args.newstring is None:
        print('Error - Need string to replace with')
        exit()


    config.regex = re.compile(args.regex)
    config.replace_with = args.newstring

    for d in args.directories:
        walk_directory(d)


    print('\nContents changed in files: \n{}'.format('\n'.join(config.changed_files)))

    if config.is_dry_run:
        print('\nWAS A DRY RUN')
