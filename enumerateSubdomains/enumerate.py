#!/bin/python
# This should be ran in rootDomain folder

import subprocess
import sys

if len(sys.argv) != 2:
    print("bad arguments, usage: python enumerate.py <rootDomain>")

root = sys.argv[1]

crtsh = subprocess.Popen([f"/usr/bin/crtsh.py {root} > ./subdomainEnumeration/crtsh.txt"], shell=True)
crtsh.wait()
print("crtsh complete (1/6)")

sublistr = subprocess.Popen([f"/opt/Sublist3r/sublist3r.py -d {root} > ./subdomainEnumeration/sublistr.txt"], shell=True)
sublistr.wait()
print("sublistr complete (2/6)")

gobusterCommonspeak = subprocess.Popen([f"gobuster dns -d {root} -w ~/bugBounty/generalResources/commonspeak_subdomains_2021_12_28.txt -o ./subdomainEnumeration/gobusterCommonspeak.txt"], shell=True)
gobusterCommonspeak.wait()
print("gobuster commonspeak done (3/6)")

gobusterJhaddix = subprocess.Popen([f"gobuster dns -d {root} -w ~/bugBounty/generalResources/allJHaddix.txt -o ./subdomainEnumeration/gobusterJhaddix.txt"], shell=True)
gobusterJhaddix.wait()
print("gobuster jhaddix done (4/6)")

rapid7 = subprocess.Popen([f"zgrep '\.{root}\",' ~/bugBounty/generalResources/sonar_rapid7_fdns_a.json.gz > ./subdomainEnumeration/rapid7.txt"], shell=True)
rapid7.wait()
print("rapid7 sonar db has been querieed (5/6)")

combined = subprocess.Popen([f"cat ./subdomainEnumeration/* | sort | uniq > ./subdomainEnumeration/subsBeforeAltDNS.txt"], shell=True)
combined.wait()
print("subs have been sorted and combined")

altDNS = subprocess.Popen([f"altdns -i ./subdomainEnumeration/subsBeforeAltDNS.txt -o ./subdomainEnumeration/permutation.txt -r -s allSubs.txt -w ~/bugBounty/generalResources/altDNSWords.txt"], shell=True)
altDNS.wait()
print("altDNS completed (6/6")

alert = subprocess.Popen([f'zenity --info --text="Job finished"'], shell=True)