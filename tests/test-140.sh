#!/usr/bin/env bash
# Non-regression on incorrect command line argument declaration (issue #1389)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I null 1 \
    -P mpe \
    -O drop \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.log
