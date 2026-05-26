#!/usr/bin/env bash
# Plugin slice

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P slice --seconds --drop 4 --pass 8 --null 12 --pass 16 \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.log
test_bin $SCRIPT.1.ts

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P slice --seconds --drop 4 --pass 8 --null 12 --pass 16 --preserve-units \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.log
test_bin $SCRIPT.2.ts

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P slice --seconds --drop 4 --pass 8 --null 12 --pass 16 --preserve-units --stuffing \
    -O file $(fpath "$OUTDIR/$SCRIPT.3.ts") \
    >"$OUTDIR/$SCRIPT.3.log" 2>&1

test_text $SCRIPT.3.log
test_bin $SCRIPT.3.ts
