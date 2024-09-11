#!/usr/bin/env bash
# Non-regression on incorrect SCTE 35 program_splice_flag (issue #1519)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tstabcomp) $(fpath "$INDIR/$SCRIPT.xml") \
    -o $(fpath "$OUTDIR/$SCRIPT.bin") \
    >"$OUTDIR/$SCRIPT.tstabcomp.log" 2>&1

test_text $SCRIPT.tstabcomp.log
test_bin $SCRIPT.bin

$(tspath tstabdump) $(fpath "$OUTDIR/$SCRIPT.bin") \
    >"$OUTDIR/$SCRIPT.tstabdump.log" 2>&1

test_text $SCRIPT.tstabdump.log
