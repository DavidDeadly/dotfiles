#!/bin/bash
# cSpell:ignore iname wholename shuf

dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if [ -z "$WALLPAPERS" ]; then
  printf "Please declare a WALLPAPERS env var like this: \n\t export WALLPAPERS=<directory>\n"
  exit 1;
fi

find "$WALLPAPERS" -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
    -not -wholename "$("$dir"/current_wallpaper.sh)" \
    | shuf -n 1
