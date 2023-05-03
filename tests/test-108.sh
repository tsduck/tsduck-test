#!/usr/bin/env bash
# Non-regression test for a crash after using demuxed sections

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P svremove 3401 \
    -O drop \
    >"$OUTDIR/$SCRIPT.log" 2>&1
echo "Exit status: $?" >"$OUTDIR/$SCRIPT.status.log" 2>&1

test_text $SCRIPT.log
test_text $SCRIPT.status.log
