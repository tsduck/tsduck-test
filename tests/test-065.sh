#!/usr/bin/env bash
# Test M2TS files.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/$SCRIPT.m2ts"
OUTFILE="$TMPDIR/$SCRIPT.m2ts"

test_tsp \
    -I file $(fpath "$INFILE") \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.analyze.txt") \
    -P psi -a -o $(fpath "$OUTDIR/$SCRIPT.psi.txt") \
    -O file $(fpath "$OUTFILE") --format m2ts \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_text $SCRIPT.tsp.log
test_text $SCRIPT.analyze.txt
test_text $SCRIPT.psi.txt

# We don't store the output file. It is large and should be identical
# to the input one. So, we just store the result of the comparison.
# We use "cmp" instead of "tscmp" to be sure to compare time stamps also.

cmp "$INFILE" "$OUTFILE" >"$OUTDIR/$SCRIPT.cmp.log" 2>&1

test_text $SCRIPT.cmp.log
