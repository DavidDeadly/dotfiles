#!/bin/bash
# cSpell:ignore swww
swww query \
    | awk -F'[: ]+' '/currently displaying/{print $NF}'
