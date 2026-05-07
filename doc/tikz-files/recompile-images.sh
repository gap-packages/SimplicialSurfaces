#!/bin/bash

# set some flags for reproducibility
export SOURCE_DATE_EPOCH=1
export FORCE_SOURCE_DATE=1
export LC_ALL=C
export TZ=UTC

find . -type f -name '_Wrapper_*.tex' -print0 |
  parallel -0 --bar '
    dir=$(dirname "{}")
    base=$(basename "{}")
    filename="${base%.tex}"
    
    (
      cd "$dir" || exit 1
      
      mkdir -p log
      logfile="log/${base}.log"
      
      # Run pdflatex silently; if it fails, print the clean error and exit
      if ! pdflatex -halt-on-error -interaction=nonstopmode -output-directory ../images "$base" > "$logfile" 2>&1; then
        echo -e "\nError compiling: $base -> Logs at: $dir/$logfile"
        exit 1
      fi
      
      # Run pdftocairo silently; if it fails, print the clean error and exit
      if ! pdftocairo -svg "../images/${filename}.pdf" "../images/${filename}-1.svg" >> "$logfile" 2>&1; then
        echo -e "\nError converting: $base -> Logs at: $dir/$logfile"
        exit 1
      fi
    )
  '
