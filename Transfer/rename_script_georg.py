# This script replaces all occurrences of "old" with "new"
# WARNING: No simultaneous replacement
# first argument: rename file with s/old/new/ in each line
# second argument: target directory
#

import os
import sys

renameFile = sys.argv[1]
targetDir = sys.argv[2]

files = [file for file in os.listdir(targetDir) if file.endswith(".g") or file.endswith(".gd") or file.endswith(".gi")]
with open(renameFile) as f:
    lines = f.readlines()
def fileToStr(path):
    with open(path) as file:
        return file.read()
contents = {file : fileToStr(file) for file in files}
for line in lines:
    split = line.split("/")
    contents = {file:contents[file].replace(split[1], split[2]) for file in contents}
for file in contents:
    with open(file, "w") as fp:
        fp.write(contents[file])
