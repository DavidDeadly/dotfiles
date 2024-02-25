#!/usr/bin/env python3

import sys
import json
import subprocess

COMMAND = "./net"


def output(interface):
    if interface is None:
        data = {
            "front": "  󰈂   Disconnected",
            "back": "Please connect  󱘖 ",
            "tooltip": "The internet is waiting...  "
        }

        sys.stdout.write(f"{json.dumps(data)}\n")
        return

    is_ethernet = interface.get("type") == "ethernet"
    ip = interface.get("ip")
    connection = interface.get("connection")
    status = interface.get("status")
    iface = interface.get("iface")

    data = {
        "front": is_ethernet and f"  󰈀   {ip}"
        or f"  󰖩   {connection}",

        "back": is_ethernet and f" {iface}:  {status} " or f" {iface}:  {ip} ",

        "tooltip": is_ethernet and f"{connection}" or f"{connection}: {status}",
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
