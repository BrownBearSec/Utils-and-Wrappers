import subprocess
import sys
import time

if len(sys.argv) != 4:
    print("bad arguements. usage: python massGitDorker.py <org file> <dork file> <token file>")
    exit()

orgFile = sys.argv[1]
dorkFile = sys.argv[2]
tokenFile = sys.argv[3]

with open(orgFile, "r") as f:
    orgs = f.readlines()
    total = len(orgs)
    counter = 0
    for i in orgs:
        counter += 1
        print(f"doing {counter}st/th org now")
        p1 = subprocess.Popen(["python", "/opt/GitDorker/GitDorker.py", "-org", f"{i.strip()}", "-d", f"{dorkFile.strip()}", "-tf", f"{tokenFile}", "-o", f"{i.strip()}"])
        p1.wait()
        time.sleep(60)