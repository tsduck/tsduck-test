#!/usr/bin/env bash
# Plugin trace.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"

test_tsp \
    -I file $(fpath "$INFILE") \
    -P trace --pid 0 \
    -O drop \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.log

test_tsp \
    -I file $(fpath "$INFILE") \
    -P filter --negate --every 1000 \
    -P filter --every 10000 --set-label 20 \
    -P trace --pid 0-10 --label 20 --format 'Index: %i, absolute index: %a, PID: %P' -o $(fpath "$OUTDIR/$SCRIPT.2.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.log
test_text $SCRIPT.2.txt
