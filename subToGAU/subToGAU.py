# This is to be ran in root-domain/

import subprocess
import sys
import os

if len(sys.argv) != 2:
    print("bad arguments, Usage: python subToGAU.py <directory>")
    exit()

directory = sys.argv[1]

folderArray = []
dirArray = os.listdir(directory)
for i in dirArray:
    if os.path.isdir(f"{directory}{i}"):
        folderArray.append(i)

print(folderArray)

for i in folderArray:
    print(f"doing {i}")
    gau = subprocess.Popen([f"gau {i} > {directory}{i}/allURLs.txt"], shell=True)
    gau.wait()
    print("all urls got, now processing gf")
    openRedirect = subprocess.Popen([f"cat {directory}{i}/allURLs.txt | gf redirect > {directory}{i}/openRedirect.txt"], shell=True)
    openRedirect.wait()
    print("gf done")