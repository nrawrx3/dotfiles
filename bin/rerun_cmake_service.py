#!/usr/bin/env python

import pyinotify
import argparse
import subprocess as sp
from sys import argv
from multiprocessing import Process, Queue

# extensions_to_watch = ['.cpp', '.h', '.cxx', '.cc', '.inc', '.hpp', '.hh', '.c', 'CMakeLists.txt']
extensions_to_watch = ['CMakeLists.txt']


def run_cmake_dot(build_dir, q):
    try:
        while True:
            r = q.get()
            if not r:
                return
            print('Running cmake')
            sp.run(['cmake', '.'], cwd=build_dir)

    except KeyboardInterrupt:
        return

class EventHandler(pyinotify.ProcessEvent):
    def __init__(self, q):
        super().__init__()
        self.q = q

    def process_IN_CLOSE_WRITE(self, event):
        print("CLOSE_WRITE event:", event.pathname)
        for e in extensions_to_watch:
            if event.pathname.endswith(e):
                print('{} - Rerunning cmake...'.format(argv[0]))
                self.q.put(True)
                break


if __name__ == '__main__':
    ap = argparse.ArgumentParser(
        description='Rerun cmake on project file change')
    ap.add_argument('--project', '-p', help='Path to project')
    ap.add_argument('--build', '-b', help='Path to build directory')

    args = ap.parse_args()

    if args.project is None or args.build is None:
        print('Both --project and --build are required')
        exit(1)

    wm = pyinotify.WatchManager()
    wm.add_watch(args.project, pyinotify.ALL_EVENTS, rec=True)

    q = Queue(4)

    eh = EventHandler(q)
    n = pyinotify.Notifier(wm, eh)

    p = Process(target=run_cmake_dot, args=(args.build, q))

    try:
        p.start()
        n.loop()
    except KeyboardInterrupt:
        p.join()

