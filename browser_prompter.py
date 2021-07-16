#!/usr/bin/env python

import subprocess as sp
from sys import argv
import tkinter as tk
from tkinter import simpledialog, messagebox

root = tk.Tk()
root.withdraw()


def get_url_type(url):
    if url.startswith('http:') or url.startswith('https:'):
        return 'http'

    if url.endswith('.pdf'):
        return 'pdf'

    return None


def ask_for_browser(url):
    user_input = simpledialog.askstring(
        title="Browser Prompter",
        prompt=f"Choose browser (c or ci = chrome, f or fi = firefox)\nURL: {url}",
    )
    user_input = user_input.strip()

    if user_input in ["c", "chrome"]:
        return ["google-chrome-stable"]

    if user_input in ["f", "firefox"]:
        return ["firefox"]

    if user_input in ["ci", "chrome -incognito"]:
        return ["google-chrome-stable", "-incognito"]

    if user_input in ["fi", "firefox -incognito"]:
        return ["firefox", "-private-window"]

    return None


def browser_action(url):
    command = ask_for_browser(url)

    if command is None:
        messagebox.showerror("Error", "Invalid browser")
        exit(1)

    command.append(url)

    sp.run(command)


def ask_for_reader(url):
    user_input = simpledialog.askstring(
        title="Browser Prompter",
        prompt=f"Choose pdf reader - (l) for llpp, (c) for chrome, (f) for firefox  \nURL: {url}",
    )
    user_input = user_input.strip()

    if user_input in ["c", "chrome"]:
        return ["google-chrome-stable"]

    if user_input in ["f", "firefox"]:
        return ["firefox"]

    if user_input in ["l", "llpp"]:
        return ["llpp"]

    return None

def pdf_reader_action(url):
    command = ask_for_reader(url)

    if command is None:
        messagebox.showerror("Error", "Invalid browser")
        exit(1)

    command.append(url)

    sp.run(command)


if __name__ == '__main__':
    if len(argv) != 2:
        messagebox.showerror("Error", f"Expected URL as parameter, but argv = {argv}")
    else:
        url = argv[1]
        url_type = get_url_type(url)

        if url_type == 'http':
            browser_action(url)

        elif url_type == 'pdf':
            pdf_reader_action(url)

        else:
            messagebox.showerror("Error", f"Unknown URL type: {url}")
