#!/bin/bash

for gdfile in $(find  -type f -name "*.gd");
do
    echo $gdfile 
    cp $gdfile $gdfile.orig
    cat $gdfile.orig | tr '\n' '%' | sed --debug -f sedin2 | tr '%' '\n'  > $gdfile.debug
    rm $gdfile.orig
done;
