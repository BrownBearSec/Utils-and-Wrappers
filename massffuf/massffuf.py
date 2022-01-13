#!/bin/python
import sys
import subprocess

if len(sys.argv) != 2:
    print("bad arguements, usage: python massffuf.py <urlList>")
    exit()

urlList = sys.argv[1]

with open(urlList, "r") as f:
    urls = f.readlines()
    for i in urls:
        if "FUZZ" in i:
            ffuf = subprocess.Popen([f"ffuf -r -p 0.1 -s --mc 301,302,307 -u {i.strip()} -w /usr/share/seclists/Payloads/openRedirect.txt 2>/dev/null >> potentiallyVulnOpenRed.txt"], shell=True)
            ffuf.wait()
        