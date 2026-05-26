#!/usr/bin/env bash
# Plugin time

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
INFILE="$INDIR/test-205.ts"

test_tsp \
    -I file $(fpath "$INFILE") \
    -P time --tdt --drop "" --pass 2020/12/14:11:16:35 --drop 2020/12/14:11:16:40 \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.log
test_bin $SCRIPT.1.ts

test_tsp \
    -I file $(fpath "$INFILE") \
    -P time --tdt --drop "" --pass 2020/12/14:11:16:35 --drop 2020/12/14:11:16:40 --preserve-units \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.log
test_bin $SCRIPT.2.ts

test_tsp \
    -I file $(fpath "$INFILE") \
    -P time --tdt --drop "" --pass 2020/12/14:11:16:35 --drop 2020/12/14:11:16:40 --preserve-units --stuffing \
    -O file $(fpath "$OUTDIR/$SCRIPT.3.ts") \
    >"$OUTDIR/$SCRIPT.3.log" 2>&1

test_text $SCRIPT.3.log
test_bin $SCRIPT.3.ts
