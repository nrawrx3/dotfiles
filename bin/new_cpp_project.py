#!/usr/bin/env python3

# Generate a CMake based C++ project

import subprocess as sp
import argparse
import typing
import os
import zipfile


class UrlType:
    GIT = 0
    ZIP = 1  # Not implemented yet
    FILE = 2 # Not implemented yet
    CMAKE_PACKAGE = 3

class FindPackageInfo:
    def __init__(self, package_name, include_dirs_found_name, libraries_name):
        self.package_name = package_name
        self.include_dirs_found_name = include_dirs_found_name
        self.libraries_name = libraries_name


class LibraryInfo:
    def __init__(self, name, url, include_dir_maker, is_c_library=False, url_type=UrlType.GIT, has_cmakelists=True):
        self.name = name
        self.url = url
        self.include_dir_maker = include_dir_maker
        self.is_c_library = is_c_library
        assert(self.name is not None and self.url is not None)
        self.url_type = url_type
        self.has_cmakelists = has_cmakelists

    def __eq__(self, other):
        return self.name == other.name

    def __hash__(self):
        return hash(self.name)


MANDATORY_LIBRARIES = [
    'scaffold',
    'argh',
    'loguru'
]

def usual_include_dir(library_name):
    return '{}/include'.format(library_name)


PREDEFINED_LIBRARY_INFO = [
    LibraryInfo('scaffold', 'https://github.com/rksht/scaffold.git', usual_include_dir),
    LibraryInfo('loguru', 'https://github.com/emilk/loguru', lambda s: s, has_cmakelists=False),
    LibraryInfo('argh', 'https://github.com/adishavit/argh.git', usual_include_dir),
    LibraryInfo('glfw', 'https://github.com/glfw/glfw.git', usual_include_dir, is_c_library=True),
    LibraryInfo('assimp', 'https://github.com/assimp/assimp.git', usual_include_dir),
    LibraryInfo('json', 'https://github.com/nlohmann/json.git', usual_include_dir),
    LibraryInfo('opencv', FindPackageInfo('OpenCV', 'OpenCV_INCLUDE_DIRS', 'OpenCV_LIBS'), None, url_type=UrlType.CMAKE_PACKAGE),
]

# Ensure no duplicates
assert len(set(PREDEFINED_LIBRARY_INFO)) == len(PREDEFINED_LIBRARY_INFO)

def make_prelude_section(projname):
    s = '''cmake_minimum_required(VERSION 3.4)

project({})

set(CMAKE_MODULE_PATH "${{PROJECT_SOURCE_DIR}}/cmake;${{CMAKE_MODULE_PATH}}")
include(extra_functions)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

option({}_BUILD_SHARED_LIB "Build a shared lib also" off)

if ("${{CMAKE_CXX_COMPILER_ID}}" STREQUAL "GNU")
	set(gcc_or_clang TRUE)
    set(is_msvc FALSE)
elseif ("${{CMAKE_CXX_COMPILER_ID}}" STREQUAL "MSVC")
	set(gcc_or_clang FALSE)
    set(is_msvc TRUE)
elseif ("${{CMAKE_CXX_COMPILER_ID}}" STREQUAL "Clang")
	set(gcc_or_clang TRUE)
    set(msvc FALSE)
endif()'''
    return s.format(projname, projname.upper())


def make_c_library_section(c_libs):
    statement = 'add_subdirectory(third/{})'
    add_commands = []
    for lib in c_libs:
        if lib.has_cmakelists:
            statement.format(lib.name)
    return '\n'.join(add_commands)

def make_stdflag_section(version=17):
    assert version in [11, 14, 17]
    s = '''if (${{gcc_or_clang}})
    add_compile_options(-std=c++{})
endif()

if (${{is_msvc}})
    add_compile_options(-std:c++latest)
endif()'''
    return s.format(version)

def make_third_party_include_dirs_section(libs):
    include_dirs_relative = [lib.include_dir_maker(lib.name) for lib in libs]
    print(include_dirs_relative)
    s = '''set(_rel_include_dirs
    {}
)
ex_prepend_to_each("${{_rel_include_dirs}}" "${{PROJECT_SOURCE_DIR}}/third/" third_party_include_dirs)'''
    s = s.format('\n    '.join(include_dirs_relative))
    return s


def make_find_packages_section(cmake_packages_libs):
    s = '''find_package({} REQUIRED)
list(APPEND third_party_include_dirs ${{{}}})
'''
    return ''.join(s.format(lib.url.package_name, lib.url.include_dirs_found_name) for lib in cmake_packages_libs)


def make_add_subdirectories_section(libs):
    add_subdir_commands = []
    for lib in libs:
        if lib.has_cmakelists:
            add_subdir_commands.append('add_subdirectory(third/{})'.format(lib.name))
    print("Add subdir commands = ", add_subdir_commands)

    s = '''set(SCAFFOLD_BUILD_SHARED_LIB ON CACHE BOOL "Build scaffold as shared lib" FORCE)
{}
add_subdirectory(src)
add_subdirectory(test)'''
    s = s.format('\n'.join(add_subdir_commands))
    return s


def make_dirs(dirpath):
    try:
        os.makedirs(dirpath)
    except FileExistsError:
        pass


class Info:
    def __init__(self, projname, thirds, dest_dir, libnames):
        self.projname = projname
        self.thirds = thirds
        self.dest_dir = dest_dir
        self.projdir = "{}/{}".format(self.dest_dir, self.projname)
        self.testdir = "{}/test".format(self.projdir)
        self.srcdir = "{}/src".format(self.projdir)

        name_to_libinfo = {}
        for info in PREDEFINED_LIBRARY_INFO:
            name_to_libinfo[info.name] = info

        self.libs = [name_to_libinfo[name] for name in libnames]

        # Add mandatory libraries
        libs_set = set(lib.name for lib in self.libs)
        mlibs_set = set(libname for libname in MANDATORY_LIBRARIES)
        need_to_add = mlibs_set - libs_set

        for lib in PREDEFINED_LIBRARY_INFO:
            if lib.name in need_to_add:
                self.libs.append(lib)

        non_mandatory_libs = libs_set - mlibs_set

        self.non_mandatory_libs = []

        for lib in self.libs:
            if lib.name in non_mandatory_libs and lib.url_type != UrlType.CMAKE_PACKAGE:
                self.non_mandatory_libs.append(lib)

        self.git_libs = []

        for lib in self.libs:
            if lib.url_type == UrlType.GIT:
                self.git_libs.append(lib)

        self.cmake_packages_libs = list(filter(lambda lib: lib.url_type == UrlType.CMAKE_PACKAGE, self.libs))
        self.non_cmake_packages_libs = list(filter(lambda lib: lib.url_type != UrlType.CMAKE_PACKAGE, self.libs))
        self.add_as_subdirectory_libs = list(filter(lambda lib: not lib.is_c_library, self.non_cmake_packages_libs))
        self.clibs = list(filter(lambda lib: lib.is_c_library, self.libs))
        self.non_cmake_packages_clibs = list(filter(lambda lib: lib.url_type != UrlType.CMAKE_PACKAGE, self.clibs))


    def generate_top_level(self):
        try:
            make_dirs(self.projdir)
            make_dirs(self.testdir)
            make_dirs(self.srcdir)
            make_dirs("{}/cmake".format(self.projdir))
        except FileExistsError:
            pass

        cmake_packages_libs = list(filter(lambda lib: lib.url_type == UrlType.CMAKE_PACKAGE, self.libs))

        cmake_top_level_generated = '{}\n{}\n{}\n{}\n{}\n{}\n'.format(
            make_prelude_section(self.projname),
            make_c_library_section(self.non_cmake_packages_clibs),
            make_stdflag_section(17),
            make_find_packages_section(cmake_packages_libs),
            make_third_party_include_dirs_section(self.non_cmake_packages_libs),
            make_add_subdirectories_section(self.add_as_subdirectory_libs))

        with open(os.path.join(self.projdir, 'CMakeLists.txt'), 'w') as f:
            f.write(cmake_top_level_generated)

        with open("{}/cmake/extra_functions.cmake".format(self.projdir), 'w') as f:
            s = '''# Every function that returns a value does so into the given `return_var` at
# the end of the arguments.

# Given `the_list`, prepends `to_prepend` to each item in this list.
function(ex_prepend_to_each the_list to_prepend return_var)
	set(prepended_items "")
	foreach(item ${the_list})
		set(prepended_items "${to_prepend}${item};${prepended_items}")
	endforeach()
	set(${return_var} "${prepended_items}" PARENT_SCOPE)
endfunction()

# Compiles the given file (should be C++) with the include directions and
# preprocessor definitions of the given target. Usually for seeing the
# assembly output, or something from clang.
function(ex_compile_one_file file_name target extra_options)
	get_target_property(include_dirs ${target} INCLUDE_DIRECTORIES)
	ex_prepend_to_each("${include_dirs}" "-I" include_dirs_flag)
	# get_target_property(compile_defs ${target} INTERFACE_COMPILE_DEFINITIONS)
	message("compiling single file ${file_name} with compile defs ${compile_defs} and include dirs ${include_dirs_flag}")
	execute_process(COMMAND g++ ${extra_options} ${include_dirs_flag} ${compile_defs} ${file_name})
endfunction()

function(place_in_folder target folder_name)
	set_target_properties(${target} PROPERTIES FOLDER ${folder_name})
endfunction()

function(add_macro_definition macro_name)
	set(_tmp "-D${macro_name}=\"${${macro_name}}\"")
	message("Adding definition - ${_tmp}")
	add_compile_options(${_tmp})
endfunction()
'''
            f.write(s)


    def generate_test_level(self):
        s = '''cmake_minimum_required(VERSION 3.4)

include(extra_functions)

# Include dirs for each test, just collect them here
set(test_include_dirs ${{third_party_include_dirs}})
list(APPEND test_include_dirs 	${{PROJECT_SOURCE_DIR}}/include
								${{PROJECT_SOURCE_DIR}}/test)

# Creates list of all subdirectories ending in _test
macro(make_subdir_list result curdir)
	file(GLOB children RELATIVE ${{curdir}} ${{curdir}}/*_test)
	set(dirlist "")
	foreach(child ${{children}})
		if(IS_DIRECTORY ${{curdir}}/${{child}})
			LIST(APPEND dirlist ${{child}})
		endif()
	endforeach()
	set(${{result}} ${{dirlist}})
endmacro()

make_subdir_list(subdirs ${{CMAKE_CURRENT_SOURCE_DIR}})
foreach(subdir ${{subdirs}})
	add_subdirectory(${{subdir}})
endforeach()
'''.format()

        with open("{}/CMakeLists.txt".format(self.testdir), 'w') as f:
            f.write(s)

        try:
            make_dirs("{}/dummy_test".format(self.testdir))
        except FileExistsError:
            pass

        c_program = '''#include <{}/fizzbuzz.h>
#include <stdio.h>
int main() {{
    printf("Hello world\\n");
}}
'''
        c_program = c_program.format(self.projname)

        with open("{}/dummy_test/dummy_test.cpp".format(self.testdir), 'w') as f:
            f.write(c_program)

        cmake_file_source = '''cmake_minimum_required(VERSION 3.4)

include_directories(${{test_include_dirs}})
add_compile_options(-march=native)

function (in_tests_folder target)
  place_in_folder(${{target}} "tests/dummy_test")
endfunction()

add_executable(dummy_test dummy_test.cpp)
target_link_libraries(dummy_test {})
in_tests_folder(dummy_test)
'''
        cmake_file_source = cmake_file_source.format(self.projname)

        with open("{}/dummy_test/CMakeLists.txt".format(self.testdir), 'w') as f:
            f.write(cmake_file_source)


    def generate_src_level(self):
        cmake_source = '''cmake_minimum_required(VERSION 3.4)

include(extra_functions)

if (gcc_or_clang)
    add_compile_options(-Wall -march=native -fmax-errors=1)
else()
    add_compile_options(-Wall)
endif()

## Source files
set(header_dir ${{PROJECT_SOURCE_DIR}}/include/{0})
set(header_files_relative fizzbuzz.h)
ex_prepend_to_each("${{header_files_relative}}" "${{header_dir}}/" header_paths)

set(source_files fizzbuzz.cpp
        ${{header_paths}}
    )

include_directories(${{third_party_include_dirs}})
include_directories(${{PROJECT_SOURCE_DIR}}/include)

add_library({0} SHARED ${{source_files}})

set(depending_libraries scaffold {1})

if (gcc_or_clang)
    LIST(APPEND depending_libraries -lstdc++fs -pthread)
endif()

target_link_libraries({0} ${{depending_libraries}})
'''
        cmake_package_lib_format = '${{{}}}'
        non_package_libraries_names = list(lib.name for lib in self.non_mandatory_libs)
        package_libraries_names = list('${' + lib.url.libraries_name + '}' for lib in self.cmake_packages_libs)
        source = cmake_source.format(self.projname, ' '.join(non_package_libraries_names + package_libraries_names))
        with open("{}/CMakeLists.txt".format(self.srcdir), 'w') as f:
            f.write(source)

        # Fizzbuzz program for testing
        fizzbuzz_cpp = '''#include <{0}/fizzbuzz.h>
const char *fizzbuzz(int n) {{
    if (n % 15 == 0) {{
        return "fizzbuzz";
    }}
    if (n % 3 == 0) {{
        return "fizz";
    }}
    if (n % 5 == 0) {{
        return "buzz";
    }}
    return "";
}}
'''
        fizzbuzz_cpp = fizzbuzz_cpp.format(self.projname)

        with open("{}/fizzbuzz.cpp".format(self.srcdir), 'w') as f:
            f.write(fizzbuzz_cpp)

        include_dir = '{}/include/{}'.format(self.projdir, self.projname)
        try:
            make_dirs(include_dir)
        except FileExistsError:
            pass

        fizzbuzz_h = '#pragma once\nconst char *fizzbuzz(int n);';

        with open('{}/fizzbuzz.h'.format(include_dir), 'w') as f:
            f.write(fizzbuzz_h)


    def git_init_submodules(self):
        working_dir = os.getcwd()

        gitmodules_entry = '''
[submodule "third/{0}"]
    path = "third/{0}"
    url = {1}'''.strip()

        source = '\n\n'.join(gitmodules_entry.format(lib.name, lib.url) for lib in self.git_libs)

        with open("{}/.gitmodules".format(self.projdir), 'w') as f:
            f.write(source)

        try:
            print("GIT INIT, ADD...")
            os.chdir(self.projdir)
            sp.run(["git", "init"])
            sp.run(["git", "add", "."])

            third_dir = "{}/third".format(self.projdir)
            try:
                make_dirs(third_dir)
            except FileExistsError:
                pass

            os.chdir(third_dir)

            for lib in self.git_libs:
                sp.run(["git", "clone", lib.url])
                print("GIT CLONE", lib.name)

            os.chdir(self.projdir)

            for lib in self.git_libs:
                path = "third/{}".format(lib.name)
                sp.run(["git", "submodule", "add", lib.url, path])
                print("GIT SUBMODULE ADD", lib.name)

            print("GIT COMMIT FIRST...")
            sp.run(["git", "commit", "-m", "First commit"])

        except Exception as e:
            print("Exception: ", e)
            os.chdir(working_dir)


def arg_list(strlist: str):
    s = strlist.strip()
    assert(len(s) >= 2)
    assert(s[0] == '[')
    assert(s[-1] == ']')
    s = s[1:-1]
    libnames = [name.strip() for name in s.split(',')]
    return libnames


if __name__ == '__main__':
    arg_parser = argparse.ArgumentParser(description='Generate a cmake based C++ project quickly')
    arg_parser.add_argument('projname', type=str, help='Name of project')
    arg_parser.add_argument('-t', '--thirds', type=str, help='List of third party library names')
    arg_parser.add_argument('-d', '--dirname', type=str, help='Directory to create the project in')

    args = arg_parser.parse_args()

    if args.thirds is not None:
        thirds = arg_list(args.thirds)
    else:
        thirds = []

    projname = args.projname

    if args.dirname is not None:
        dirname = args.dirname
    else:
        dirname = os.getcwd().replace("\\", "/")


    info = Info(projname, thirds, dirname, thirds)
    info.generate_top_level()
    info.generate_test_level()
    info.generate_src_level()
    info.git_init_submodules()
