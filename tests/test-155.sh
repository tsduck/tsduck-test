#!/usr/bin/env bash
# tables plugin with option --joint-termination

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp --bitrate 1000000 \
    -I file $(fpath "$INDIR/test-002.ts") \
    -P tables --joint-termination --all-sections --pid 0 --max-tables 5 -o $(fpath "$OUTDIR/$SCRIPT.pid0.txt") \
    -P tables --joint-termination --all-sections --pid 20 --max-tables 5 -o $(fpath "$OUTDIR/$SCRIPT.pid20.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.log
test_text $SCRIPT.pid0.txt
test_text $SCRIPT.pid20.txt
