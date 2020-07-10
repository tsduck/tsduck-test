#!/bin/bash
# EIT normalization

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Without EIT normalization
$(tspath tstabcomp) \
    $(fpath "$INDIR/$SCRIPT.xml") \
    -o $(fpath "$OUTDIR/$SCRIPT.1.bin") \
    >"$OUTDIR/$SCRIPT.comp.1.log" 2>&1

test_text $SCRIPT.comp.1.log
test_bin $SCRIPT.1.bin

$(tspath tstabdump) $(fpath "$OUTDIR/$SCRIPT.1.bin") \
    >"$OUTDIR/$SCRIPT.1.txt" 2>"$OUTDIR/$SCRIPT.dump.1.log"

test_text $SCRIPT.dump.1.log
test_text $SCRIPT.1.txt

# Using default time base
$(tspath tstabcomp) --eit-normalization \
    $(fpath "$INDIR/$SCRIPT.xml") \
    -o $(fpath "$OUTDIR/$SCRIPT.2.bin") \
    >"$OUTDIR/$SCRIPT.comp.2.log" 2>&1

test_text $SCRIPT.comp.2.log
test_bin $SCRIPT.2.bin

$(tspath tstabdump) $(fpath "$OUTDIR/$SCRIPT.2.bin") \
    >"$OUTDIR/$SCRIPT.2.txt" 2>"$OUTDIR/$SCRIPT.dump.2.log"

test_text $SCRIPT.dump.2.log
test_text $SCRIPT.2.txt

# Using explicit time base
$(tspath tstabcomp) --eit-normalization --eit-base-date 2020/06/09 \
    $(fpath "$INDIR/$SCRIPT.xml") \
    -o $(fpath "$OUTDIR/$SCRIPT.3.bin") \
    >"$OUTDIR/$SCRIPT.comp.3.log" 2>&1

test_text $SCRIPT.comp.3.log
test_bin $SCRIPT.3.bin

$(tspath tstabdump) $(fpath "$OUTDIR/$SCRIPT.3.bin") \
    >"$OUTDIR/$SCRIPT.3.txt" 2>"$OUTDIR/$SCRIPT.dump.3.log"

test_text $SCRIPT.dump.3.log
test_text $SCRIPT.3.txt
