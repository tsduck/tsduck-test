#!/bin/bash
# Test craft plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tsp) --synchronous-log \
    -I craft --count 2 --cc 3 --pusi --scrambling 2 --error --payload-size 100 --payload-pattern 785412 --pcr 0x456123 \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1

test_bin $SCRIPT.1.ts
test_text $SCRIPT.tsp.1.log

$(tspath tsdump) $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.tsdump.1.txt" \
    2>"$OUTDIR/$SCRIPT.tsdump.1.log"

test_text $SCRIPT.tsdump.1.txt
test_text $SCRIPT.tsdump.1.log

$(tspath tsp) --synchronous-log \
    -I craft --count 2 --cc 7 --no-payload --private-data 96321478 --es-priority --discontinuity --splice-countdown 0x8A \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1

test_bin $SCRIPT.2.ts
test_text $SCRIPT.tsp.2.log

$(tspath tsdump) $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.tsdump.2.txt" \
    2>"$OUTDIR/$SCRIPT.tsdump.2.log"

test_text $SCRIPT.tsdump.2.txt
test_text $SCRIPT.tsdump.2.log
