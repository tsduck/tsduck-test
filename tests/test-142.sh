#!/usr/bin/env bash
# Non-regression on tsp looping on corrupted TS packet (issue #1398)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -O drop \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.log
