#!/usr/bin/env bash
# Test zap plugin with option --ignore-absent

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P zap France5 \
    -P pcrbitrate --min-pcr 32 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.analyze.1.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1

test_bin $SCRIPT.1.ts
test_text $SCRIPT.tsp.1.log
test_text $SCRIPT.analyze.1.txt

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P zap France5 --ignore-absent \
    -P pcrbitrate --min-pcr 32 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.analyze.2.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1

test_bin $SCRIPT.2.ts
test_text $SCRIPT.tsp.2.log
test_text $SCRIPT.analyze.2.txt

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P zap 0x0415 --ignore-absent \
    -P pcrbitrate --min-pcr 32 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.analyze.3.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.3.ts") \
    >"$OUTDIR/$SCRIPT.tsp.3.log" 2>&1

test_bin $SCRIPT.3.ts
test_text $SCRIPT.tsp.3.log
test_text $SCRIPT.analyze.3.txt
