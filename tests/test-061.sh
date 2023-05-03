#!/usr/bin/env bash
# Order of sections in plugin inject

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"

test_tsp \
    -I file $(fpath "$INFILE") --repeat 10 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.analyze.in.txt") \
    -P inject $(fpath "$INDIR/$SCRIPT.xml")=1000 --pid 16 --replace --stuffing \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.analyze.out.txt") \
    -P tables --pid 16 --all-sections --log --packet-index -o $(fpath "$OUTDIR/$SCRIPT.tables.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_text $SCRIPT.tsp.log
test_text $SCRIPT.tables.txt
test_text $SCRIPT.analyze.in.txt
test_text $SCRIPT.analyze.out.txt
