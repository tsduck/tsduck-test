#!/bin/bash
# Test "reduce" plugin.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P zap 0x2263 --stuffing \
    -P stats -o $(fpath "$OUTDIR/$SCRIPT.stats.1.txt") \
    -P reduce --target-bitrate 3,000,000 --pcr-based --time-window 1,000 \
    -P pcrbitrate --min-pid 1 --min-pcr 8 \
    -P stats -o $(fpath "$OUTDIR/$SCRIPT.stats.2.txt") \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.analyze.txt") \
    -O file  $(fpath "$OUTDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.stats.1.txt
test_text $SCRIPT.stats.2.txt
test_text $SCRIPT.analyze.txt
test_text $SCRIPT.log
test_bin $SCRIPT.ts
