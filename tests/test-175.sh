#!/usr/bin/env bash
# Test tsfclean

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-092.ts"

$(tspath tsfclean) $(fpath "$INFILE") -o - 2>"$OUTDIR/$SCRIPT.tsfclean.log" |
    tsp -P history -O drop >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_text $SCRIPT.tsfclean.log
test_text $SCRIPT.tsp.log

grep '* history:' "$OUTDIR/$SCRIPT.tsp.log" |
    sort -t : -k 2 -n \
    >"$OUTDIR/$SCRIPT.history.log" 2>&1

test_text $SCRIPT.history.log
