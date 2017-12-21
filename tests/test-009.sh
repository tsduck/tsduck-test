#!/bin/bash
# Test rmorphan plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"

$(tspath tsp) \
    -I file $(fpath "$INFILE") \
    -P filter -n -p 1 -p 16 -p 17 -p 18 \
    -P pat -i -u -r 8801 -r 8802 -r 8803 -r 8804 -r 8805 -r 8806 -r 8807 -r 8808 -r 8809 -r 8899 \
    -P rmorphan \
    -P pcrbitrate --min-pcr 32 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.analyze.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_bin $SCRIPT.ts
test_text $SCRIPT.tsp.log
test_text $SCRIPT.analyze.txt
