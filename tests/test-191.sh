#!/usr/bin/env bash
# Encoding order of DVB character sets

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tstabcomp) $(fpath "$INDIR/$SCRIPT.xml") \
    --output $(fpath "$OUTDIR/$SCRIPT.1.bin") \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_bin $SCRIPT.1.bin
test_text $SCRIPT.1.log

$(tspath tstabcomp) $(fpath "$OUTDIR/$SCRIPT.1.bin") \
    --output $(fpath "$OUTDIR/$SCRIPT.2.xml") \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.xml
test_text $SCRIPT.2.log

$(tspath tstabdump) $(fpath "$OUTDIR/$SCRIPT.1.bin") \
    >"$OUTDIR/$SCRIPT.3.log" 2>&1

test_text $SCRIPT.3.log

$(tspath tstabdump) --default-charset DUMP $(fpath "$OUTDIR/$SCRIPT.1.bin") \
    >"$OUTDIR/$SCRIPT.4.log" 2>&1

test_text $SCRIPT.4.log
