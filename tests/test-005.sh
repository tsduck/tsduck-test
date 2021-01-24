#!/bin/bash
# Test tstabcomp

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
source "$COMMONDIR"/standard-si-test.sh $SCRIPT.xml

# Tests on standard input/output.

$(tspath tstabcomp) --compile - \
    <"$INDIR/$SCRIPT.xml" \
    >"$OUTDIR/$SCRIPT.std1.bin" \
    2>"$OUTDIR/$SCRIPT.std1.log"

test_bin $SCRIPT.std1.bin
test_text $SCRIPT.std1.log

$(tspath tstabcomp) --decompile - \
    <"$OUTDIR/$SCRIPT.std1.bin" \
    >"$OUTDIR/$SCRIPT.std2.xml" \
    2>"$OUTDIR/$SCRIPT.std2.log"

test_text $SCRIPT.std2.xml
test_text $SCRIPT.std2.log

$(tspath tstabcomp) $(fpath "$OUTDIR/$SCRIPT.std1.bin") -o - \
    >"$OUTDIR/$SCRIPT.std3.xml" \
    2>"$OUTDIR/$SCRIPT.std3.log"

test_text $SCRIPT.std3.xml
test_text $SCRIPT.std3.log

$(tspath tstabcomp) $(fpath "$INDIR/$SCRIPT.xml") -o - \
    >"$OUTDIR/$SCRIPT.std4.bin" \
    2>"$OUTDIR/$SCRIPT.std4.log"

test_bin $SCRIPT.std4.bin
test_text $SCRIPT.std4.log
