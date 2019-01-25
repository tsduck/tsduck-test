#!/bin/bash
# Test multiple CW in text file for scrambler plugin.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P scrambler 0x226A --atis --cw-file $(fpath "$INDIR/$SCRIPT.cw.txt") --cp-duration 2 \
    -P zap 0x226A \
    -O file $(fpath "$OUTDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_bin $SCRIPT.ts
test_text $SCRIPT.log
