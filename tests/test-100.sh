#!/usr/bin/env bash
# Non-regression on HEVC access unit formatting (issue #830)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.1.ts") \
    -P pes --pid 0x0101 --avc-access-unit --h26x-default-format hevc -o $(fpath "$OUTDIR/$SCRIPT.1.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.txt
test_text $SCRIPT.1.log

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.2.ts") \
    -P pes --pid 0x01E1 --avc-access-unit --h26x-default-format hevc -o $(fpath "$OUTDIR/$SCRIPT.2.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.txt
test_text $SCRIPT.2.log
