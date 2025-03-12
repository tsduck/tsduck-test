#!/usr/bin/env bash
# Non-regression on incorrect TS with inconsistent standards (issue #1590)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tstables) --japan $(fpath "$INDIR/$SCRIPT.ts") \
    --text-output $(fpath "$OUTDIR/$SCRIPT.txt") \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.log
test_text $SCRIPT.txt
