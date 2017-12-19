#!/bin/bash
# Test tstabcomp

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-005.xml"

$(tspath tstabcomp) $(fpath "$INFILE") --output $(fpath "$OUTDIR/$SCRIPT.compile.bin") \
    2>"$OUTDIR/$SCRIPT.compile.log" 2>&1

test_bin $SCRIPT.compile.bin
test_text $SCRIPT.compile.log

$(tspath tstabcomp) $(fpath "$OUTDIR/$SCRIPT.compile.bin") --decompile --output $(fpath "$OUTDIR/$SCRIPT.decompile.xml") \
    2>"$OUTDIR/$SCRIPT.decompile.log" 2>&1

test_text $SCRIPT.decompile.xml
test_text $SCRIPT.decompile.log
