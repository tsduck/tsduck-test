#!/usr/bin/env bash
# Non-regression on tstables with large truncated sections.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tstables) --invalid-sections \
    $(fpath "$INDIR/$SCRIPT.ts") \
    --output $(fpath "$OUTDIR/$SCRIPT.txt") \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.txt
test_text $SCRIPT.log
