#!/bin/sh

# ~/.local/bin/nixvim.sh
# ----------------------

# On NixOS due to the lack of libtinfo.so I have created a symlink at
# ~/.local/lib. So LD_LIBRARY_PATH that

thepath=$HOME/.local/lib/libtinfo.so.5


if [ ! -e "$thepath" ] ; then
  echo "$thepath does not point to the required shared lib!! Fix that"
fi

LD_LIBRARY_PATH=$HOME/.local/lib subl3 $@
