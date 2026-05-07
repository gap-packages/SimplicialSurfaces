#!/bin/bash

# set some flags for reproducibility
export SOURCE_DATE_EPOCH=1
export FORCE_SOURCE_DATE=1
export LC_ALL=C
export TZ=UTC

parallel --bar '
    mkdir -p log
    logfile="log/{}.log"

    # Run pdflatex silently; if it fails, print the clean error and exit
    if ! pdflatex -halt-on-error -interaction=nonstopmode -output-directory ../images {} > "$logfile" 2>&1; then
        echo -e "\nError compiling: {} -> Logs at: $logfile"
        exit 1
    fi

    # Run pdftocairo silently; if it fails, print the clean error and exit
    if ! pdftocairo -svg "../images/{.}.pdf" "../images/{.}-1.svg" >> "$logfile" 2>&1; then
        echo -e "\nError converting: {} -> Logs at: $logfile"
        exit 1
    fi
' ::: _Wrapper_*.tex
