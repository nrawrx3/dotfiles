#!/bin/sh

# On NixOS due to the lack of libtinfo.so I have created a symlink at
# ~/.local/lib. So LD_LIBRARY_PATH that

LD_LIBRARY_PATH=$HOME/.local/lib nvim
