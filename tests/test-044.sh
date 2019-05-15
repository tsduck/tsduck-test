#!/bin/bash
# Test craft plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Create some packets, test 1
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

# Create some packets, test 2
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

# Test option --pack-pes-header.
$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INDIR/$SCRIPT.pes.ts") \
    -P craft --pack-pes-header \
    -O file $(fpath "$OUTDIR/$SCRIPT.3.ts") \
    >"$OUTDIR/$SCRIPT.tsp.3.log" 2>&1

test_bin $SCRIPT.3.ts
test_text $SCRIPT.tsp.3.log

$(tspath tsdump) $(fpath "$OUTDIR/$SCRIPT.3.ts") \
    >"$OUTDIR/$SCRIPT.tsdump.3.txt" \
    2>"$OUTDIR/$SCRIPT.tsdump.3.log"

test_text $SCRIPT.tsdump.3.txt
test_text $SCRIPT.tsdump.3.log
