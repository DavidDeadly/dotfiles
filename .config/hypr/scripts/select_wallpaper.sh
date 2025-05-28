#!/usr/bin/env bash
# cSpell:ignore fuzzel iname dmenu wholename swww

dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -z "$WALLPAPERS" ]; then
  printf "Please declare a WALLPAPERS env var like this: \n\t export WALLPAPERS=<directory>\n"
  exit 1;
fi

# sort by length ascendent, show just the image name
img=$(
    find "$WALLPAPERS" -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
        -not -wholename "$("$dir"/current_wallpaper.sh)"\
        -printf "%f\n" \
        | fuzzel --dmenu
)

if [ -z "$img" ]; then
    exit 1;
fi

echo "$WALLPAPERS/$img"
