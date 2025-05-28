#!/bin/sh
# cSpell:ignore swww
swww query \
    | awk -F'[: ]+' '/currently displaying/{print $NF}'
