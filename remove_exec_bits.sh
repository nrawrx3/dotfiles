#!/usr/bin/sh

# Recursively removes the executable permission from all regular files in a
# directory

# Old split character
OIFS="$IFS"

# Only split on newlines
IFS=$'\n'

DIR=$1

for file in `find $DIR -type f`
do
     echo "chmod -x $file"
     chmod -x $file
     #read line
done

for file in `find $DIR -type d`
do
  echo "chmod o-w $file"
  chmod o-w $file
done

# Restore previous split characters
IFS="$OIFS"
