#!/usr/bin/env bash
# Test Free TV Australia logical channel descriptor

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

source "$COMMONDIR"/standard-si-test.sh $SCRIPT.xml

$(tspath tstables) $(fpath "$INDIR/$SCRIPT.ts") \
    --text-output $(fpath "$OUTDIR/$SCRIPT.2.txt") \
    --xml-output $(fpath "$OUTDIR/$SCRIPT.2.xml") \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.log
test_text $SCRIPT.2.txt
test_text $SCRIPT.2.xml
