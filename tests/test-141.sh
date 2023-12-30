#!/usr/bin/env bash
# Test option --meta-sections in tstables

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
INFILE="$INDIR/test-001.ts"

$(tspath tstables) $(fpath "$INFILE") --meta-sections --pid 16 \
    --xml-output $(fpath "$OUTDIR/$SCRIPT.xml") \
    --json-output $(fpath "$OUTDIR/$SCRIPT.json") \
    --binary-output $(fpath "$OUTDIR/$SCRIPT.1.bin") \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.log
test_text $SCRIPT.xml
test_text $SCRIPT.json
test_bin $SCRIPT.1.bin

$(tspath tstabcomp) $(fpath "$OUTDIR/$SCRIPT.xml") \
    --output $(fpath "$OUTDIR/$SCRIPT.2.bin") \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.log
test_bin $SCRIPT.2.bin

$(tspath tstabcomp) $(fpath "$OUTDIR/$SCRIPT.json") \
    --output $(fpath "$OUTDIR/$SCRIPT.3.bin") \
    >"$OUTDIR/$SCRIPT.3.log" 2>&1

test_text $SCRIPT.3.log
test_bin $SCRIPT.3.bin

$(tspath tstabcomp) $(fpath "$OUTDIR/$SCRIPT.2.bin") \
    --output $(fpath "$OUTDIR/$SCRIPT.2.xml") \
    >"$OUTDIR/$SCRIPT.4.log" 2>&1

test_text $SCRIPT.4.log
test_text $SCRIPT.2.xml

$(tspath tstabcomp) $(fpath "$OUTDIR/$SCRIPT.3.bin") \
    --output $(fpath "$OUTDIR/$SCRIPT.3.json") \
    >"$OUTDIR/$SCRIPT.5.log" 2>&1

test_text $SCRIPT.5.log
test_text $SCRIPT.3.json
