import subprocess
import sys
from typing import Counter

if len(sys.argv) != 3:
    print("bad arguements. usage: python gobusterMass.py <root domain file> <wordlist>")
    exit()

rootDomainFile = sys.argv[1]
wordlist = sys.argv[2]


with open(rootDomainFile, "r") as f:
    domains = f.readlines()
    total = len(domains)
    counter = 0
    for i in domains:
        counter += 1
        if (counter % 25 == 0):
            print(f"Progress: ({counter}/{total})")
        p1 = subprocess.Popen(["gobuster", "dns", "-d", f"{i.strip()}", "-w", f"{wordlist.strip()}", "-q"])
        p1.wait()
