#!/usr/bin/env bash
# Non-regression on a crash in plugin teletext (issue #1400)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P teletext --pid 0x003E --output-file $(fpath "$OUTDIR/$SCRIPT.srt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.log
test_text $SCRIPT.srt
