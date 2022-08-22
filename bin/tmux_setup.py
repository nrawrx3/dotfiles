#!/usr/bin/env python
# coding: utf-8
from os import system, getenv
from pathlib import Path


def tmux(command):
    system('tmux %s' % command)

PROJECT_PATH = Path(getenv('HOME')) / 'werk' / sys.argv[1]


def tmux_shell(command):
    tmux('send-keys "%s" "C-m"' % command)

# example: one tab with vim, other tab with two consoles (vertical split)
# with virtualenvs on the project, and a third tab with the server running

# vim in project
tmux('select-window -t 0')
tmux_shell('cd %s' % PROJECT_PATH)
tmux_shell('vim')
tmux('rename-window "vim"')

# console in project
tmux('new-window')
tmux('select-window -t 1')
tmux_shell('cd %s' % PROJECT_PATH)
tmux('rename-window "consola"')
# second console as split
tmux('split-window -v')
tmux('select-pane -t 1')
tmux_shell('cd %s' % PROJECT_PATH)
tmux_shell(ACTIVATE_VENV)
tmux('rename-window "consola"')

# local server
tmux('new-window')
tmux('select-window -t 2')
tmux_shell('cd %s' % PROJECT_PATH)
tmux_shell(ACTIVATE_VENV)
tmux_shell('python manage.py runserver')
tmux('rename-window "server"')

# go back to the first window
tmux('select-window -t 0')
