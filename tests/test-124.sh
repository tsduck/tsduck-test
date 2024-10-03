#!/usr/bin/env bash
# Plugin sections with option --patch-xml

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I file $(fpath "$INDIR/test-092.ts") \
    -P inject --pid 16 --replace $(fpath "$INDIR/$SCRIPT.nit.xml") \
    -P sections --pid 16 --patch-xml $(fpath "$INDIR/$SCRIPT.patch.xml") \
    -P sections --pid 18 --patch-xml $(fpath "$INDIR/$SCRIPT.patch.xml") \
    -P tables --pid 16 -o $(fpath "$OUTDIR/$SCRIPT.nit.out.txt") \
    -P tables --pid 18 --all-sections -o $(fpath "$OUTDIR/$SCRIPT.eit.out.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.nit.out.txt
test_text $SCRIPT.eit.out.txt
test_text $SCRIPT.log
test_bin $SCRIPT.ts

test_tsp \
    -I file $(fpath "$INDIR/test-084.ts") \
    -P tables --pid 1055 --packet-index --xml $(fpath "$OUTDIR/$SCRIPT.2.in.xml") \
    -P sections --pid 1055 --patch-xml $(fpath "$INDIR/$SCRIPT.patch.2.xml") \
    -P tables --pid 1055 --packet-index -o $(fpath "$OUTDIR/$SCRIPT.2.txt") \
    -P tables --pid 1055 --packet-index --xml $(fpath "$OUTDIR/$SCRIPT.2.out.xml") \
    -O drop \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.in.xml
test_text $SCRIPT.2.txt
test_text $SCRIPT.2.out.xml
test_text $SCRIPT.2.log
