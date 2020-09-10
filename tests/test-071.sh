#!/bin/bash
# Test RS204 files.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INDIR/test-001.ts") \
    -P until --packets 200 \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") --format rs204 \
    >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1

test_text $SCRIPT.tsp.1.log
test_bin $SCRIPT.1.ts

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1

test_text $SCRIPT.tsp.2.log
test_bin $SCRIPT.2.ts

$(tspath tsdump) --max-packets 5 \
    $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >$(fpath "$OUTDIR/$SCRIPT.1.txt") \
    2>"$OUTDIR/$SCRIPT.tsdump.1.log"

test_text $SCRIPT.tsdump.1.log
test_text $SCRIPT.1.txt

$(tspath tsdump) --max-packets 5 \
    $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >$(fpath "$OUTDIR/$SCRIPT.2.txt") \
    2>"$OUTDIR/$SCRIPT.tsdump.2.log"

test_text $SCRIPT.tsdump.2.log
test_text $SCRIPT.2.txt
