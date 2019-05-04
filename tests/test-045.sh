#!/bin/bash
# Test timeref plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-002.ts"

$(tspath tsp) --synchronous-log --bitrate 45,034,955 \
    -I file $(fpath "$INFILE") \
    -P timeref --start 2020/01/01:12:00:00 --eit \
    -P tables --packet-index -a -p 0x12 -p 0x14 -o $(fpath "$OUTDIR/$SCRIPT.tables.1.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1

test_bin $SCRIPT.1.ts
test_text $SCRIPT.tables.1.txt
test_text $SCRIPT.tsp.1.log

$(tspath tsp) --synchronous-log --bitrate 45,034,955 \
    -I file $(fpath "$INFILE") \
    -P timeref --add 3600 --notdt \
    -P tables --packet-index -a -p 0x12 -p 0x14 -o $(fpath "$OUTDIR/$SCRIPT.tables.2.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1

test_bin $SCRIPT.2.ts
test_text $SCRIPT.tables.2.txt
test_text $SCRIPT.tsp.2.log
