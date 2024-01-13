#!/usr/bin/env bash
# pcrcopy plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-092.ts"

test_tsp \
    -I file $(fpath "$INFILE") \
    -P svremove 0x0105 --stuffing \
    -P count --pid 630 --summary -o $(fpath "$OUTDIR/$SCRIPT.count.1a.txt") \
    -P pes --pid 630 --save-pes $(fpath "$TMPDIR/$SCRIPT.1a.pes") \
    -P pcrcopy --reference-pid 620 --target-pid 630 \
    -P pes --pid 630 --save-pes $(fpath "$TMPDIR/$SCRIPT.1b.pes") \
    -P count --pid 630 --summary -o $(fpath "$OUTDIR/$SCRIPT.count.1b.txt") \
    -P pcrextract --pid 620-630 --pcr --csv -o $(fpath "$OUTDIR/$SCRIPT.1.csv") \
    -P zap 0x0106 \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.count.1a.txt
test_text $SCRIPT.count.1b.txt
test_text $SCRIPT.1.csv
test_text $SCRIPT.1.log
test_bin $SCRIPT.1.ts

cmp $(fpath "$TMPDIR/$SCRIPT.1a.pes") $(fpath "$TMPDIR/$SCRIPT.1b.pes") \
    >"$OUTDIR/$SCRIPT.cmp.1.log" 2>&1

test_text $SCRIPT.cmp.1.log

# verify pcrcopy with labels
test_tsp --verbose \
    -I file $(fpath "$INFILE") \
    -P filter -p 0x140 --set-label 0 \
    -P pcrcopy --reference-pid 0x78 --target-pid 0x82 \
    -P pcrextract --pcr --csv -o $(fpath "$OUTDIR/$SCRIPT.2.csv") \
    -O drop \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.csv
test_text $SCRIPT.2.log

test_tsp --verbose \
    -I file $(fpath "$INFILE") \
    -P filter -p 0x140 --set-label 0 \
    -P pcrcopy --reference-label 0 --target-pid 0x82 \
    -P pcrextract --pcr --csv -o $(fpath "$OUTDIR/$SCRIPT.3.csv") \
    -O drop \
    >"$OUTDIR/$SCRIPT.3.log" 2>&1

test_text $SCRIPT.3.csv
test_text $SCRIPT.3.log

test_tsp --verbose \
    -I file $(fpath "$INFILE") \
    -P filter -p 0x140 --set-label 1 \
    -P pcrcopy --reference-label 1 --target-pid 0x82 \
    -P pcrextract --pcr --csv -o $(fpath "$OUTDIR/$SCRIPT.4.csv") \
    -O drop \
    >"$OUTDIR/$SCRIPT.4.log" 2>&1

test_text $SCRIPT.4.csv
test_text $SCRIPT.4.log
