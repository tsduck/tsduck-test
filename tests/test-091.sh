#!/usr/bin/env bash
# Non-regression on SCTE 35 tables with unspecified command length (issue #764)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tstables) $(fpath "$INDIR/$SCRIPT.ts") \
    --text $(fpath "$OUTDIR/$SCRIPT.txt") \
    --xml $(fpath "$OUTDIR/$SCRIPT.xml") \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.txt
test_text $SCRIPT.xml
test_text $SCRIPT.log
