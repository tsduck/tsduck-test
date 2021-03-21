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
