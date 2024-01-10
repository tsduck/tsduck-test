#!/usr/bin/env bash
# Non-regression on PCR computation in plugin pcredit (issue #1411)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I null 1 \
    -P craft --pid 100 --pcr 0 --no-payload \
    -P dump --headers-only \
    -P pcredit --add-pcr -1 -u pts \
    -P dump --headers-only \
    -O drop \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.log
