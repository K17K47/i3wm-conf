#!/bin/sh

USERNAME=$(whoami)

find ./conf/ -type f | while:
do
   read FILENAME
   sed 's/<username>/$USERNAME/g' $FILENAME > $FILENAME
done


