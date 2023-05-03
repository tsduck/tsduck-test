#!/usr/bin/env bash
# Test duplicate plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"

test_tsp --add-stop-stuffing 1000 \
    -I file $(fpath "$INFILE") \
    -P zap cnews --cas --stuffing \
    -P duplicate 0x1600-0x16FF=0x1700 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.out.txt") \
    -P filter -n -p 0x1FFF \
    -O file $(fpath "$OUTDIR/$SCRIPT.out.ts") \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_bin $SCRIPT.out.ts
test_text $SCRIPT.out.txt
test_text $SCRIPT.log

# Extract one sample PID in temporary directory (not saved in repository).

test_tsp \
    -I file $(fpath "$OUTDIR/$SCRIPT.out.ts") \
    -P filter -p 0x164E \
    -O file $(fpath "$TMPDIR/$SCRIPT.pid1.ts") \
    >"$OUTDIR/$SCRIPT.pid1.log" 2>&1

test_tsp \
    -I file $(fpath "$OUTDIR/$SCRIPT.out.ts") \
    -P filter -p 0x174E \
    -O file $(fpath "$TMPDIR/$SCRIPT.pid2.ts") \
    >"$OUTDIR/$SCRIPT.pid2.log" 2>&1

test_text $SCRIPT.pid1.log
test_text $SCRIPT.pid2.log

cd "$TMPDIR"
$(tspath tscmp) --continue --pid-ignore "$SCRIPT.pid1.ts" "$SCRIPT.pid2.ts" \
    >"$OUTDIR/$SCRIPT.cmp.log" 2>&1

test_text $SCRIPT.cmp.log
