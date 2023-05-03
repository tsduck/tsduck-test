#!/usr/bin/env bash
# pcredit plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-092.ts"

test_tsp \
    -I file $(fpath "$INFILE") \
    -P pcrextract -o $(fpath "$OUTDIR/$SCRIPT.1a.txt") \
    -P pcredit --add-pcr -2 --add-pts 2 --add-dts 1 \
    -P pcrextract -o $(fpath "$OUTDIR/$SCRIPT.1b.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1a.txt
test_text $SCRIPT.1b.txt
test_text $SCRIPT.1.log
