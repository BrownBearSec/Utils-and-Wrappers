import subprocess
import sys

if len(sys.argv) != 2:
    print("bad arguments, usage: python massZgrep.py <rootDomainFile>")

rootFile = sys.argv[1]

commandString = "zgrep '"

with open(rootFile, "r") as f:
    domains = f.readlines()
    for i in domains:
        i = i.replace(".", "\\.")
        commandString += f"\\.{i.strip()}\\\",\|"

commandString = commandString[:-2]
commandString += "' ~/bugBounty/generalResources/sonar_rapid7_fdns_a.json.gz | jq -Mr '.name' | anew allSubs.txt"

print(commandString)
p1 = subprocess.Popen([commandString], shell=True)
p1.wait()