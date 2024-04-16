#!/bin/bash
# cSpell:ignore wofi iname dmenu wholename

dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if [ -z "$WALLPAPERS" ]; then
  printf "Please declare a WALLPAPERS env var like this: \n\t export WALLPAPERS=<directory>\n"
  exit 1;
fi

# sort by length ascendent, show just the image name
find "$WALLPAPERS" -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
    ! -wholename "$("$dir"/current_wallpaper.sh)"\
    -printf "%f\n" \
    | wofi --dmenu -W 150 -H 200 --pre-display-cmd \
    "echo '%s' | sed 's/-/ /g' | sed 's/\.[^.]*$//' | sed -E 's/\b(\w)/\U\1/g'"
