#!/usr/bin/env bash
# Test psimerge plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE1="$INDIR/test-001.ts"
INFILE2="$INDIR/test-002.ts"

test_tsp \
    -I file --interleave $(fpath "$INFILE1") $(fpath "$INFILE2") --label-base 1 \
    -P analyze --only-label 1 -o $(fpath "$OUTDIR/$SCRIPT.1.txt") \
    -P analyze --only-label 2 -o $(fpath "$OUTDIR/$SCRIPT.2.txt") \
    -P psimerge --main-label 1 --merge-label 2 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.merged.txt") \
    -P psi -a -o $(fpath "$OUTDIR/$SCRIPT.psi.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.1.txt
test_text $SCRIPT.2.txt
test_text $SCRIPT.merged.txt
test_text $SCRIPT.psi.txt
test_text $SCRIPT.log
