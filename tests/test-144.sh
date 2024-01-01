#!/usr/bin/env bash
# Non-regression on a crash in plugin pes (issue #1401)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P pes --pid 0x003D --audio-attributes --video-attributes \
    -O drop \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.log
