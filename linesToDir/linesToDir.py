"""
Utility to take a list of words, and turn each line into a new directory.
"""

import sys
import os

if len(sys.argv) != 2:
    print("Bad arguments, Usage: python linesToDir.py <file>")
    exit()

filename = sys.argv[1]

with open(filename) as f:
    lines = f.readlines()
    print(f"This will create {len(lines)} directories in the folder {os.getcwd()}")
    input("Either click enter to continue, or Ctrl+C to cancel")
    for i in lines:
        os.mkdir(i.strip())