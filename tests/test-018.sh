#!/usr/bin/env bash
# Test AIT extraction

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-018.ts"

test_tsp \
    -I file $(fpath "$INFILE") \
    -P tables --pid 0x1ec5 \
              --text $(fpath "$OUTDIR/$SCRIPT.ait.1ec5.txt") \
              --xml $(fpath "$OUTDIR/$SCRIPT.ait.1ec5.xml") \
    -P tables --pid 0x1ec6 \
              --text $(fpath "$OUTDIR/$SCRIPT.ait.1ec6.txt") \
              --xml $(fpath "$OUTDIR/$SCRIPT.ait.1ec6.xml") \
    -O file $(fpath "$OUTDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_bin $SCRIPT.ts
test_text $SCRIPT.tsp.log
test_text $SCRIPT.ait.1ec5.txt
test_text $SCRIPT.ait.1ec5.xml
test_text $SCRIPT.ait.1ec6.txt
test_text $SCRIPT.ait.1ec6.xml
