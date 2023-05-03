#!/usr/bin/env bash
# Test tsp stuffing options.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/$SCRIPT.ts"

test_tsp --add-start-stuffing 3 --add-stop-stuffing 4 \
    -I file $(fpath "$INFILE") \
    -O file $(fpath "$OUTDIR/$SCRIPT.start.ts") \
    >"$OUTDIR/$SCRIPT.tsp.start.log" 2>&1

test_bin $SCRIPT.start.ts
test_text $SCRIPT.tsp.start.log

test_tsp --add-input-stuffing 1/3 \
    -I file $(fpath "$INFILE") \
    -O file $(fpath "$OUTDIR/$SCRIPT.middle.ts") \
    >"$OUTDIR/$SCRIPT.tsp.middle.log" 2>&1

test_bin $SCRIPT.middle.ts
test_text $SCRIPT.tsp.middle.log
