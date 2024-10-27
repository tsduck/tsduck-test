#!/usr/bin/env bash
# Options --only-labels and --except-label in tsp plugins

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I null \
    -P until -p 1000 \
    -P filter --every 2 --set-label 2 \
    -P filter --every 5 --set-label 5 \
    -P count --tag "all" \
    -P count --tag "  2" --only-label 2 \
    -P count --tag "  5" --only-label 5 \
    -P count --tag "2+5" --only-label 2-5 \
    -P count --tag "2-5" --only-label 2 --except-label 5 \
    -O drop \
    >"$OUTDIR/$SCRIPT.log" 2>&1
