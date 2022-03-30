#!/bin/bash
# Test hls output plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -O hls $(fpath "$OUTDIR/$SCRIPT-.ts") --duration 4 --intra-close --playlist $(fpath "$OUTDIR/$SCRIPT.m3u8") \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.log
test_text $SCRIPT.m3u8
test_bin $SCRIPT-000000.ts
test_bin $SCRIPT-000001.ts
test_bin $SCRIPT-000002.ts
test_bin $SCRIPT-000003.ts

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -O hls $(fpath "$OUTDIR/$SCRIPT.event-.ts") --duration 4 --intra-close --event --playlist $(fpath "$OUTDIR/$SCRIPT.event.m3u8") \
    >"$OUTDIR/$SCRIPT.event.log" 2>&1

test_text $SCRIPT.event.log
test_text $SCRIPT.event.m3u8
test_bin $SCRIPT.event-000000.ts
test_bin $SCRIPT.event-000001.ts
test_bin $SCRIPT.event-000002.ts
test_bin $SCRIPT.event-000003.ts

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -O hls $(fpath "$OUTDIR/$SCRIPT.live-.ts") --duration 4 --intra-close --live 2 --playlist $(fpath "$OUTDIR/$SCRIPT.live.m3u8") \
    >"$OUTDIR/$SCRIPT.live.log" 2>&1

test_text $SCRIPT.live.log
test_text $SCRIPT.live.m3u8
test_bin $SCRIPT.live-000002.ts
test_bin $SCRIPT.live-000003.ts

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INDIR/$SCRIPT.ts") --packet-offset 20,000 \
    -O hls $(fpath "$OUTDIR/$SCRIPT.align-.ts") --duration 4 --intra-close --align-first-segment --playlist $(fpath "$OUTDIR/$SCRIPT.align.m3u8") \
    >"$OUTDIR/$SCRIPT.align.log" 2>&1

test_text $SCRIPT.align.log
test_text $SCRIPT.align.m3u8
test_bin $SCRIPT.align-000000.ts
test_bin $SCRIPT.align-000001.ts
