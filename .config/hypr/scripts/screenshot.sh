#!/bin/bash

SAVE_DIR=~/Screenshots
mkdir -p "$SAVE_DIR"

FILENAME="$(date '+%Y%m%d_%H%M%S')".png
SAVE_PATH=$SAVE_DIR/$FILENAME

should_select_area=$1

# freeze and no zoom
hyprpicker -r -z & sleep 0.2
HYPRPICKER_PID=$!

if [ "$should_select_area" = true ]; then
    grim -g "$(slurp -d -c '#94e2d5')" "$SAVE_PATH"
else
    grim -o "$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')" "$SAVE_PATH"
fi

kill "$HYPRPICKER_PID"

wl-copy --type image/png < "$SAVE_PATH"

satty --filename "$SAVE_PATH" --fullscreen -o "$SAVE_DIR"/edited_"$FILENAME"  --action-on-enter save-to-file
