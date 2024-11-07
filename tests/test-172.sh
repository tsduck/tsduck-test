#!/usr/bin/env bash
# Plugin history.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"

test_tsp \
    -I file $(fpath "$INFILE") \
    -P history \
    -O drop \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.log

test_tsp \
    -I file $(fpath "$INFILE") \
    -P history --cas --eit --intra-frame --time-all -o $(fpath "$OUTDIR/$SCRIPT.2.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.log
test_text $SCRIPT.2.txt
