#!/usr/bin/env bash
# Test tables with lots of diacritics (Czech EIT's).

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tstabdump) $(fpath "$INDIR/$SCRIPT.bin") \
    >"$OUTDIR/$SCRIPT.tstabdump.txt" \
    2>"$OUTDIR/$SCRIPT.tstabdump.log"

test_text $SCRIPT.tstabdump.txt
test_text $SCRIPT.tstabdump.log

$(tspath tspacketize) -p 18 $(fpath "$INDIR/$SCRIPT.bin") \
    -o $(fpath "$OUTDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.tspacketize.log" 2>&1

test_bin $SCRIPT.ts
test_text $SCRIPT.tspacketize.log

$(tspath tstables) --fill-eit $(fpath "$OUTDIR/$SCRIPT.ts") \
    --text $(fpath "$OUTDIR/$SCRIPT.tstables.txt") \
    --xml $(fpath "$OUTDIR/$SCRIPT.xml") \
    >"$OUTDIR/$SCRIPT.tstables.log" 2>&1

test_text $SCRIPT.xml
test_text $SCRIPT.tstables.txt
test_text $SCRIPT.tstables.log
