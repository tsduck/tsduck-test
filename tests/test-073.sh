#!/bin/bash
# Test "stats" plugin.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --every 10 --set-label 1 \
    -P filter --every 7 --set-label 2 \
    -P stats -o $(fpath "$OUTDIR/$SCRIPT.stats.pids.txt") \
    -P stats -o $(fpath "$OUTDIR/$SCRIPT.stats.labels.txt") --label 1-2 \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_text $SCRIPT.stats.pids.txt
test_text $SCRIPT.stats.labels.txt
test_text $SCRIPT.tsp.log
