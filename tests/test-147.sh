#!/usr/bin/env bash
# tsfuzz and plugin fuzz

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
INFILE="$INDIR/test-072.ts"
SEED=DA4DCDBC8F3290E365B1B0DD9BE8F2F92490A438D00E6DE804A9D170DD571CEA
PROB=1/1000

$(tspath tsfuzz) $(fpath "$INFILE") -o $(fpath "$OUTDIR/$SCRIPT.ts") \
    --seed $SEED --corrupt-probability $PROB \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.log
test_bin $SCRIPT.ts

$(tspath tscmp) --continue $(fpath "$INFILE") $(fpath "$OUTDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.log

test_tsp \
    -I file $(fpath "$INFILE") \
    -P fuzz --seed $SEED --corrupt-probability $PROB \
    -O file $(fpath "$TMPDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.3.log" 2>&1

test_text $SCRIPT.3.log

$(tspath tscmp) --continue $(fpath "$OUTDIR/$SCRIPT.ts") $(fpath "$TMPDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.4.log" 2>&1

test_text $SCRIPT.4.log
