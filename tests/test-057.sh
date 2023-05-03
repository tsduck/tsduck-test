#!/usr/bin/env bash
# Test hls input plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I hls https://tsduck.io/download/test/hls/channel/Animals.m3u8 \
    -P until --packets 12 \
    -O file $(fpath "$OUTDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_bin $SCRIPT.ts
test_text $SCRIPT.log
