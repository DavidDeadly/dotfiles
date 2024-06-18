#!/usr/bin/env bash
# cSpell:ignore wofi iname dmenu wholename swww

if [ -z "$WALLPAPERS" ]; then
    printf "Please declare a WALLPAPERS env var like this: \n\t export WALLPAPERS=<directory>\n"
    exit 1;
fi

current=$(
    swww query \
        | awk -F'[: ]+' '/currently displaying/{print $NF}'
)

# sort by length ascendent, show just the image name
img=$(
    find "$WALLPAPERS" -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
        -not -wholename "$current"\
        -printf "%f\n" \
        | wofi --dmenu --pre-display-cmd \
        "echo '%s' | sed 's/-/ /g' | sed 's/\.[^.]*$//' | sed -E 's/\b(\w)/\U\1/g'"
)

if [ -z "$img" ]; then
    exit 1;
fi

echo "$WALLPAPERS/$img"
