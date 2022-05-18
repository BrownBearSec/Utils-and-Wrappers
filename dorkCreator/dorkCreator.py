"""Dork creator - creates long google dorks

Creator: Joseph Sm9l Witten
Started: 18 May 2022
Github: https://github.com/iamSm9l

Inputs:
- REQUIRED Target file, a file containing domains to search; one on each line
- REQUIRED dork, eg "ext:doc | ext:docx | ext:odt | ext:rtf | ext:sxw | ext:psw | ext:ppt | ext:pptx | ext:pps | ext:csv"

Outputs (Stdout):
- A dork containing all targets and given dork (recommended that you pipe this tool into "xclip -sel clip")


Usage:
- python dorkCreator.py <targetFile> <dork>

Example:
- python dorkCreator.py targets "ext:xml | ext:conf | ext:cnf | ext:reg | ext:inf | ext:rdp | ext:cfg | ext:txt | ext:ora | ext:ini | ext:env" | xclip -sel clip
"""

import sys
import os

if len(sys.argv) != 3:
    print("bad arguments, Usage: python dorkCreator.py <targetFile> <dork>")
    exit()

targetFile = sys.argv[1]
dork = sys.argv[2]

final = "("

with open(targetFile, "r") as f:
    targets = f.readlines()
    for i in targets:
        final += "site:" + i.rstrip() + " | "
    final = final[:len(final)-3]
    final += ")"

final += " " + dork
print(final)