"""Dork creator - creates long google dorks

Creator: Alana nynan Witten
Started: 18 March 2023
Github: https://github.com/iamNynan

Inputs:
- REQUIRED Target file, a file containing domains to search; one on each line
- REQUIRED dork, eg "ext:doc | ext:docx | ext:odt | ext:rtf | ext:sxw | ext:psw | ext:ppt | ext:pptx | ext:pps | ext:csv"
- REQUIRED dork length, eg 'intitle:"index of"' == 1, 'intitle:"index of" "database"' == 2

Outputs (Stdout):
- A set of dorks that are within google's 32 dork limit


Usage:
- python dorkCreator.py <targetFile> <dork> <dorkFile>

Example:
- python dorkCreator.py targets "ext:xml | ext:conf | ext:cnf | ext:reg | ext:inf | ext:rdp | ext:cfg | ext:txt | ext:ora | ext:ini | ext:env" 11
"""

import sys

if len(sys.argv) != 4:
    print("bad arguments, Usage: python dorkCreator.py <targetFile> <dork> <dorkLength>")
    exit()

targetFile = sys.argv[1]
dork = sys.argv[2]
dorkLength = [3]

line = dork

with open(targetFile, "r") as f:
    targets = f.readlines()
    targets = list(map(str.strip, targets))
    targets = list(map(lambda x: "site:" + x, targets))
    for i in range(0,len(targets), (32 - dorkLength[0])):
        split_string = targets[i:i+(32 - dorkLength[0])]
        part = " | ".join(split_string)
        print(dork + " " + part)

        