#!/usr/bin/env bash
# Test pcrverify plugin.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/$SCRIPT.ts"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P pcrverify --jitter-max 100,000 \
    -P pcrextract --pcr -o $(fpath "$OUTDIR/$SCRIPT.pcr.csv") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_text $SCRIPT.tsp.log
test_text $SCRIPT.pcr.csv
