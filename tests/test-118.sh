#!/bin/bash
# Test tstabcomp with --eit-normalization

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tstabcomp) $(fpath "$INDIR/$SCRIPT.xml") \
    --eit-normalization \
    --output $(fpath "$OUTDIR/$SCRIPT.1.bin") \
    &>"$OUTDIR/$SCRIPT.1.comp.log"

test_text $SCRIPT.1.comp.log
test_bin $SCRIPT.1.bin

$(tspath tstabdump) $(fpath "$OUTDIR/$SCRIPT.1.bin") \
    >"$OUTDIR/$SCRIPT.1.txt" \
    2>"$OUTDIR/$SCRIPT.1.dump.log"

test_text $SCRIPT.1.comp.log
test_text $SCRIPT.1.txt

$(tspath tstabcomp) $(fpath "$INDIR/$SCRIPT.xml") \
    --eit-normalization --eit-base-date 2022-10-14-14:00:00 \
    --output $(fpath "$OUTDIR/$SCRIPT.2.bin") \
    &>"$OUTDIR/$SCRIPT.2.comp.log"

test_text $SCRIPT.2.comp.log
test_bin $SCRIPT.2.bin

$(tspath tstabdump) $(fpath "$OUTDIR/$SCRIPT.2.bin") \
    >"$OUTDIR/$SCRIPT.2.txt" \
    2>"$OUTDIR/$SCRIPT.2.dump.log"

test_text $SCRIPT.2.comp.log
test_text $SCRIPT.2.txt

$(tspath tstabcomp) $(fpath "$INDIR/$SCRIPT.xml") \
    --eit-normalization --eit-normalization --eit-base-date 2022-10-14-15:00:00 --eit-pf \
    --output $(fpath "$OUTDIR/$SCRIPT.3.bin") \
    &>"$OUTDIR/$SCRIPT.3.comp.log"

test_text $SCRIPT.3.comp.log
test_bin $SCRIPT.3.bin

$(tspath tstabdump) $(fpath "$OUTDIR/$SCRIPT.3.bin") \
    >"$OUTDIR/$SCRIPT.3.txt" \
    2>"$OUTDIR/$SCRIPT.3.dump.log"

test_text $SCRIPT.3.comp.log
test_text $SCRIPT.3.txt
