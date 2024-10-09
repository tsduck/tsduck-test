#!/usr/bin/env bash
# Analyze an ISDB live stream with software download

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
source "$COMMONDIR"/standard-ts-test.sh $SCRIPT.ts

$(tspath tstables) $(fpath "$INDIR/$SCRIPT.ts") --pid 0x17 \
    --text $(fpath "$OUTDIR/$SCRIPT.dct.txt") \
    --xml $(fpath "$OUTDIR/$SCRIPT.dct.xml") \
    --json $(fpath "$OUTDIR/$SCRIPT.dct.json") \
    >"$OUTDIR/$SCRIPT.dct.log" 2>&1

test_text $SCRIPT.dct.log
test_text $SCRIPT.dct.txt
test_text $SCRIPT.dct.xml
test_text $SCRIPT.dct.json

$(tspath tstables) $(fpath "$INDIR/$SCRIPT.ts") --pid 0x1C00 --max-tables 4 \
    --text $(fpath "$OUTDIR/$SCRIPT.dlt.txt") \
    --xml $(fpath "$OUTDIR/$SCRIPT.dlt.xml") \
    --json $(fpath "$OUTDIR/$SCRIPT.dlt.json") \
    >"$OUTDIR/$SCRIPT.dlt.log" 2>&1

test_text $SCRIPT.dlt.log
test_text $SCRIPT.dlt.txt
test_text $SCRIPT.dlt.xml
test_text $SCRIPT.dlt.json
