#!/usr/bin/env bash
# Test tsdump in raw mode

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-004.dat"

$(tspath tsdump) $(fpath "$INFILE") --raw --ascii --binary --offset \
    >"$OUTDIR/$SCRIPT.tsdump.raw.txt" \
    2>"$OUTDIR/$SCRIPT.tsdump.raw.log"

test_text $SCRIPT.tsdump.raw.txt
test_text $SCRIPT.tsdump.raw.log

$(tspath tsdump) $(fpath "$INFILE") --raw --c-style \
    >"$OUTDIR/$SCRIPT.tsdump.c.txt" \
    2>"$OUTDIR/$SCRIPT.tsdump.c.log"

test_text $SCRIPT.tsdump.c.txt
test_text $SCRIPT.tsdump.c.log
