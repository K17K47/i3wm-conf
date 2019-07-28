#!/bin/sh

USERNAME=$(whoami)

find ./conf/ -type f | while read FILENAME
do
   sed "s/<username>/$USERNAME/g" $FILENAME > "$FILENAME"
done


