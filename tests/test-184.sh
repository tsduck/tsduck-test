#!/usr/bin/env bash
# Plugin eit with EPG dump

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P eit -o $(fpath "$OUTDIR/$SCRIPT.1.txt") \
    -P eit --epg-dump --detailed -o $(fpath "$OUTDIR/$SCRIPT.2.txt") \
    -P eit --epg-dump --summary -o $(fpath "$OUTDIR/$SCRIPT.3.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.1.txt
test_text $SCRIPT.2.txt
test_text $SCRIPT.3.txt
test_text $SCRIPT.log
