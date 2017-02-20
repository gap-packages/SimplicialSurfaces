import os
files = [file for file in os.listdir(".") if file.endswith(".g") or file.endswith(".gd") or file.endswith(".gi")]
with open("rename") as f:
    lines = f.readlines()
def fileToStr(path):
    with open(path) as file:
        return file.read()
contents = {file : fileToStr(file) for file in files}
for line in lines:
    splitted = line.split("/")
    contents = {file:contents[file].replace(splitted[1], splitted[2]) for file in contents}
for file in contents:
    with open(file, "w") as fp:
        fp.write(contents[file])
