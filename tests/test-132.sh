#!/usr/bin/env bash
# Non-regression on plugin zap and options --audio-pid and --subtitles-pid.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"

test_tsp \
    -I file $(fpath "$INFILE") \
    -P zap 8801 --audio-pid 0x007A --subtitles-pid 0x008F \
    -P until --bytes 1,000,000 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.txt
test_text $SCRIPT.log
test_bin $SCRIPT.ts
