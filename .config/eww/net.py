#!/usr/bin/env python3

import sys
import json
import subprocess

COMMAND = "./net"


def output(interface):
    if interface is None:
        data = {
            "label": "󰈂 Disconnected",
            "tooltip": "The internet is waiting... "
        }

        sys.stdout.write(f"{json.dumps(data)}\n")
        return

    is_ethernet = interface.get("type") == "ethernet"
    ip = interface.get("ip")
    connection = interface.get("connection")
    iface = interface.get("iface")

    data = {
        "label": is_ethernet and f"󰈀 {ip}"
        or f"󰖩 {connection}",

        "tooltip": is_ethernet and f"{iface}: {connection}" or f"{iface}: {ip}",
    }

    sys.stdout.write(f"{json.dumps(data)}\n")


result = subprocess.run([COMMAND], stdout=subprocess.PIPE)
interfaces = json.loads(result.stdout.decode())

found = next(
    (interface for interface in interfaces if interface["type"] == "ethernet"),
    None
)

if found is None:
    try:
        output(interfaces[0])
    except IndexError:
        output(None)
else:
    output(found)
