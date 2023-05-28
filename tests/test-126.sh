#!/usr/bin/env bash
# Delete nodes and parents using XML patch files.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tsxml) $(fpath "$INDIR/$SCRIPT.data.1.xml") \
    --patch $(fpath "$INDIR/$SCRIPT.patch.1.xml") \
    --output $(fpath "$OUTDIR/$SCRIPT.out.1.xml") \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.out.1.xml
test_text $SCRIPT.1.log

test_tsp \
    -I file $(fpath "$INDIR/test-092.ts") \
    -P sections --pid 18 --patch-xml $(fpath "$INDIR/$SCRIPT.patch.2.xml") \
    -P tables --pid 18 --all-sections -o $(fpath "$OUTDIR/$SCRIPT.tables.2.txt") \
    -P filter --pid 18 \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.tables.2.txt
test_text $SCRIPT.2.log
test_bin $SCRIPT.2.ts
