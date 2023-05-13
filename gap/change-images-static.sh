#!/bin/bash

for gdfile in $(find  -type f -name "*.gd");
do
    echo $gdfile 
    cp $gdfile $gdfile.orig
    cat $gdfile.orig | tr '\n' '%' | sed -f sedin | tr '%' '\n'  > $gdfile
    rm $gdfile.orig
done;
