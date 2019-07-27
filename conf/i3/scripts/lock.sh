#!/bin/sh

scrot -q100 /tmp/screenshot.png
ffmpeg -loglevel quiet -y -i /tmp/screenshot.png -vf "gblur=sigma=8" /tmp/screenshot.png
i3lock -i /tmp/screenshot.png
