#!/bin/sh
# cSpell:ignore swww iname shuf

wallpaper_path=$1

# if swww is down, awake it
swww query || swww init

swww img "$wallpaper_path" \
    --transition-type=any \
    --transition-fps=60  \
    --transition-duration=4 \
