#!/usr/bin/env bash
# Test tsp -O file --append

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I craft --pid 100 --count 1 \
    -O file $(fpath "$OUTDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1

test_text $SCRIPT.tsp.1.log

$(tspath tsdump) $(fpath "$OUTDIR/$SCRIPT.ts") >"$OUTDIR/$SCRIPT.tsdump.1.txt" 2>"$OUTDIR/$SCRIPT.tsdump.1.log"

test_text $SCRIPT.tsdump.1.txt
test_text $SCRIPT.tsdump.1.log

test_tsp \
    -I craft --pid 200 --count 2 --payload-pattern DEADBEEF \
    -O file $(fpath "$OUTDIR/$SCRIPT.ts") --append \
    >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1

test_text $SCRIPT.tsp.2.log
test_bin $SCRIPT.ts

$(tspath tsdump) $(fpath "$OUTDIR/$SCRIPT.ts") >"$OUTDIR/$SCRIPT.tsdump.2.txt" 2>"$OUTDIR/$SCRIPT.tsdump.2.log"

test_text $SCRIPT.tsdump.2.txt
test_text $SCRIPT.tsdump.2.log
