#!/usr/bin/env python

import subprocess as sp
from sys import argv
import tkinter as tk
from tkinter import simpledialog, messagebox

root = tk.Tk()
root.withdraw()


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


if __name__ == '__main__':
    if len(argv) != 2:
        messagebox.showerror("Error", f"Expected URL as parameter, but argv = {argv}")
    else:
        url = argv[1]
        browser_command = ask_for_browser(url)

        if browser_command is None:
            messagebox.showerror("Error", "Invalid browser")
            exit(1)

        browser_command.append(url)

        sp.run(browser_command)
