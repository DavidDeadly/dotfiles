#!/bin/sh

eval "$(grep -m 1 '^Exec=' ~/.local/share/applications/brave-excalidraw.desktop | cut -d'=' -f2-)"
