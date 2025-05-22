#!/bin/bash

for texfile in $(find . -type f -name "_Wrapper_*.tex");
do
    # cp $gdfile $gdfile.orig
    # cat $gdfile.orig | tr '\n' '%' | sed -f sedin | tr '%' '\n'  > $gdfile
    # rm $gdfile.orig
    pdflatex -halt-on-error -output-directory ../images $texfile
    htlatex $texfile
done;
mv *.svg ../images
