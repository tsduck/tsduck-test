#!/usr/bin/env bash
# rmsplice plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
INFILE="$INDIR/test-149.ts"

test_tsp \
    -I file $(fpath "$INFILE") \
    -P rmsplice --adjust-time \
    -O file $(fpath "$OUTDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.log
test_bin $SCRIPT.ts
