#!/usr/bin/env bash
# Plugin mpeextract

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P mpeextract \
    -P analyze --output-file $(fpath "$OUTDIR/$SCRIPT.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.log
test_text $SCRIPT.txt
test_bin $SCRIPT.ts
