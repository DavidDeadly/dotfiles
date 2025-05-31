#!/bin/bash

while true; do
    bat_lvl=$(cat /sys/class/power_supply/BAT1/capacity)

    if [ "$bat_lvl" -gt 51 ]; then
        sleep 120
        continue
    fi

    notify-send --urgency=CRITICAL "Battery Low" "Level: ${bat_lvl}%"
    sleep 1200
done
