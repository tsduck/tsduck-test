#!/usr/bin/env bash
# Multi-section real-world SES Astra SGT

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tstabcomp) --default-pds astra --default-charset ISO-8859-9 \
    $(fpath "$INDIR/$SCRIPT.bin") \
    --output $(fpath "$OUTDIR/$SCRIPT.1.xml") \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.xml
test_text $SCRIPT.1.log

$(tspath tstabcomp) --fix-missing-pds $(fpath "$OUTDIR/$SCRIPT.1.xml") \
    --output $(fpath "$OUTDIR/$SCRIPT.2.bin") \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_bin $SCRIPT.2.bin
test_text $SCRIPT.2.log

$(tspath tstabcomp) $(fpath "$OUTDIR/$SCRIPT.2.bin") \
    --output $(fpath "$OUTDIR/$SCRIPT.3.xml") \
    >"$OUTDIR/$SCRIPT.3.log" 2>&1

test_text $SCRIPT.3.xml
test_text $SCRIPT.3.log

$(tspath tstabdump) $(fpath "$OUTDIR/$SCRIPT.2.bin") \
    >"$OUTDIR/$SCRIPT.4.log" 2>&1

test_text $SCRIPT.4.log
