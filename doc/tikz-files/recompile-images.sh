#!/bin/bash

# set some flags for reproducibility
export SOURCE_DATE_EPOCH=1
export FORCE_SOURCE_DATE=1
export LC_ALL=C
export TZ=UTC

parallel --bar -j 8 --halt soon,fail=1 '
    pdflatex -halt-on-error -output-directory ../images {} &&
    pdftocairo -svg ../images/{.}.pdf ../images/{.}-1.svg
' ::: _Wrapper_*.tex
