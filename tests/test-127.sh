#!/usr/bin/env bash
# Non-regression on display of DVB service prominence descriptor (issue #1227)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tstables) $(fpath "$INDIR/$SCRIPT.ts") \
    -o $(fpath "$OUTDIR/$SCRIPT.txt") \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.txt
test_text $SCRIPT.log
