#!/bin/bash

for gdfile in $(find  -type f -name "*.gd");
do
    echo $gdfile 
    cp $gdfile $gdfile.orig
#    cat $gdfile.orig | tr '\r\n' '%' | sed --debug -f sed-images-static | tr '%' '\r\n'  > $gdfile.changed
    cat $gdfile.orig | tr -s '\r\n' '%' | sed --debug -f sed-images-static > $gdfile.changed
    rm $gdfile.orig
done;
