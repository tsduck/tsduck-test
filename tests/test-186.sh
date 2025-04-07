#!/usr/bin/env bash
# Real-world SIT from NHK

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

for i in 1 2; do

    $(tspath tstables) --japan $(fpath "$INDIR/$SCRIPT.$i.ts") \
        --text-output $(fpath "$OUTDIR/$SCRIPT.$i.txt") \
        --xml-output $(fpath "$OUTDIR/$SCRIPT.$i.xml") \
        >"$OUTDIR/$SCRIPT.tstables.$i.log" 2>&1

    test_text $SCRIPT.$i.txt
    test_text $SCRIPT.$i.xml
    test_text $SCRIPT.tstables.$i.log

    $(tspath tstabcomp) --japan $(fpath "$OUTDIR/$SCRIPT.$i.xml") \
        --output $(fpath "$OUTDIR/$SCRIPT.$i.bin") \
        >"$OUTDIR/$SCRIPT.compile.$i.log" 2>&1

    test_bin $SCRIPT.$i.bin
    test_text $SCRIPT.compile.$i.log

    $(tspath tstabcomp) --japan $(fpath "$OUTDIR/$SCRIPT.$i.bin") \
        --output $(fpath "$OUTDIR/$SCRIPT.decompile.$i.xml") \
        >"$OUTDIR/$SCRIPT.decompile.$i.log" 2>&1

    test_text $SCRIPT.decompile.$i.xml
    test_text $SCRIPT.decompile.$i.log

done
