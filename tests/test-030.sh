#!/bin/bash
# Sections plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.analyze.in.txt") \
    -P sections -p 0x00 -p 0x12 -p 0x112 -o 0x444 --tid-remove 0x4F \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.analyze.out.txt") \
    -P tables -a -o $(fpath "$OUTDIR/$SCRIPT.tables.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.out.ts") \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_bin $SCRIPT.out.ts
test_text $SCRIPT.analyze.in.txt
test_text $SCRIPT.analyze.out.txt
test_text $SCRIPT.tables.txt
test_text $SCRIPT.tsp.log
