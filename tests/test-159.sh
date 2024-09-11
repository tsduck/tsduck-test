#!/usr/bin/env bash
# Non regression on incorrect use of stdout in tstabcomp

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Check default output file, in same directory as input file.

cp "$INDIR/$SCRIPT.xml" "$OUTDIR/$SCRIPT.xml" >"$OUTDIR/$SCRIPT.cp.log" 2>&1
test_text $SCRIPT.cp.log

$(tspath tstabcomp) $(fpath "$OUTDIR/$SCRIPT.xml") >"$OUTDIR/$SCRIPT.tstabcomp.log" 2>&1
test_text $SCRIPT.tstabcomp.log
test_bin $SCRIPT.bin

rm "$OUTDIR/$SCRIPT.xml" >"$OUTDIR/$SCRIPT.rm.log" 2>&1
test_text $SCRIPT.rm.log

$(tspath tstabdump) $(fpath "$OUTDIR/$SCRIPT.bin") >"$OUTDIR/$SCRIPT.tstabdump.log" 2>&1
test_text $SCRIPT.tstabdump.log
