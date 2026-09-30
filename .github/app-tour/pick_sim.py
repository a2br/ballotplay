"""Prints the UDID of the best available iPad simulator.

Prefers a 13-inch iPad Pro on an iOS 17/18 runtime, the era the app was built for.
"""
import json
import re
import subprocess
import sys

data = json.loads(subprocess.check_output(["xcrun", "simctl", "list", "devices", "available", "-j"]))

ranked = []
for runtime, devices in data["devices"].items():
    m = re.search(r"iOS-(\d+)-(\d+)", runtime)
    if not m:
        continue
    version = (int(m.group(1)), int(m.group(2)))
    for d in devices:
        name = d["name"]
        if "iPad" not in name:
            continue
        if "iPad Pro 13" in name:
            fit = 3
        elif "iPad Pro (12.9" in name:
            fit = 2
        elif "iPad Air 13" in name:
            fit = 1
        else:
            fit = 0
        ranked.append((version[0] < 26, fit, version, d["udid"], name))

ranked.sort(reverse=True)
for r in ranked[:10]:
    print(r, file=sys.stderr)
if not ranked:
    sys.exit("no iPad simulator available")
print(f"Using {ranked[0][4]} (iOS {ranked[0][2][0]}.{ranked[0][2][1]})", file=sys.stderr)
print(ranked[0][3])
