#!/bin/python
"""
Find lines unique to a file, given a directory of text files. Usefull for finding rare subdomains 
"""

import sys
import os
import time

if len(sys.argv) != 2:
    print("bad arguments, Usage: python findUnique.py <directory>")
    exit()

directory = sys.argv[1]
fileArray = []

for f in os.listdir(directory):
    fileArray.append(f)


for i in fileArray:
    
    unique = []
    tempFile = f"temp-{int(time.time())}"

    #create a file, with contents of all files minus the search file
    for j in fileArray:
        if j != i:
            with open(tempFile, "a") as f:
                f.write(open(f"{directory}{j}").read() + "\n")


    #clean array of big file    
    tempFileLines = open(tempFile, "r").readlines()
    for j in range(0,len(tempFileLines)):
        tempFileLines[j] = tempFileLines[j].strip()


    #check if lines in one file, is in contents of all others
    with open(f"{directory}{i}") as f:
        lines = f.readlines()
        for j in lines:
            if j.strip() not in tempFileLines:
                unique.append(j)
    
    print(f"[+] {i} has {len(unique)} number of unique subdomains: {unique}")

    os.remove(tempFile)

print("cat * | sort | uniq > subsBeforeAltDNS.txt")