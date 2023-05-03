#!/usr/bin/env bash
# Non-regression on HEVC sequence parameter set analysis (issue #1191)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P pes --h26x-default-format hevc --avc-access-unit --nal-unit-type 0x21 -o $(fpath "$OUTDIR/$SCRIPT.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.txt
test_text $SCRIPT.log
