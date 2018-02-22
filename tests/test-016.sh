#!/bin/bash
# Test AIT extraction

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-016.ts"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P tables --pid 0x1ec5 -o $(fpath "$OUTDIR/$SCRIPT.ait.txt") \
    -P tables --pid 0x1ec6 --xml-output $(fpath "$OUTDIR/$SCRIPT.ait.xml") \
    -O file $(fpath "$OUTDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_bin $SCRIPT.ts
test_text $SCRIPT.tsp.log
test_text $SCRIPT.ait.txt
test_text $SCRIPT.ait.xml
