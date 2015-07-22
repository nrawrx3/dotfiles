#!/bin/python

import random
import sys
import os

QUOTE_DIR = os.path.join(os.getenv("HOME"), "dotfiles/quotes")

l = os.listdir(QUOTE_DIR)
f = open(os.path.join(QUOTE_DIR, l[random.randint(0, len(l) - 1)]), 'r')
print(f.read())
