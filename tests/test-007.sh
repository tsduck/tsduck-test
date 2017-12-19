#!/bin/bash
# Test various tsp plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"

$(tspath tsp) \
    -I file $(fpath "$INFILE") \
    -P bat --bouquet 0xC001 --increment-version \
    -P cat --add 0x1234/777/01020304 --remove-casid 0x1811 --increment-version \
    -P eit -o $(fpath "$OUTDIR/$SCRIPT.eit.txt") \
    -P filter -n -p 0x0BC9 -p 0x019A -p 0x01FE -p 0x0262 -p 0x02C6 -p 0x032A -p 0x038E -p 0x03F2 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.analyze.txt") \
    -P tables --pid 17 --tid 74 -o $(fpath "$OUTDIR/$SCRIPT.bat.txt") \
    -P tables --pid 1 --tid 1 -o $(fpath "$OUTDIR/$SCRIPT.cat.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_bin $SCRIPT.ts
test_text $SCRIPT.tsp.log
test_text $SCRIPT.analyze.txt
test_text $SCRIPT.eit.txt
test_text $SCRIPT.bat.txt
test_text $SCRIPT.cat.txt
