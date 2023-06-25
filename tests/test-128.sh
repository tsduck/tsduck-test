#!/usr/bin/env bash
# Plugin "feed".

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

source "$COMMONDIR"/standard-ts-test.sh $SCRIPT.ts

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P feed -p 701 -o $(fpath "$OUTDIR/$SCRIPT.701.ts") \
    -P feed -p 702 -o $(fpath "$OUTDIR/$SCRIPT.702.ts") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.all.log" 2>&1

test_bin $SCRIPT.701.ts
test_bin $SCRIPT.702.ts
test_text $SCRIPT.tsp.all.log

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P feed -p 701 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.701.txt") \
    -O file $(fpath "$TMPDIR/$SCRIPT.701a.ts") \
    >"$OUTDIR/$SCRIPT.tsp.701.log" 2>&1

test_text $SCRIPT.701.txt
test_text $SCRIPT.tsp.701.log

cmp $(fpath "$OUTDIR/$SCRIPT.701.ts") $(fpath "$TMPDIR/$SCRIPT.701a.ts") \
    >"$OUTDIR/$SCRIPT.cmp.701.log" 2>&1

test_text $SCRIPT.cmp.701.log

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P feed -p 702 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.702.txt") \
    -O file $(fpath "$TMPDIR/$SCRIPT.702a.ts") \
    >"$OUTDIR/$SCRIPT.tsp.702.log" 2>&1

test_text $SCRIPT.702.txt
test_text $SCRIPT.tsp.702.log

cmp $(fpath "$OUTDIR/$SCRIPT.702.ts") $(fpath "$TMPDIR/$SCRIPT.702a.ts") \
    >"$OUTDIR/$SCRIPT.cmp.702.log" 2>&1

test_text $SCRIPT.cmp.702.log
