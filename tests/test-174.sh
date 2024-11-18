#!/usr/bin/env bash
# Plugin isdbinfo.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-170.ts"

test_tsp \
    -I file $(fpath "$INFILE") \
    -P filter --every 1000 --set-label 1 \
    -P craft --only-label 1 --delete-rs204 \
    -P isdbinfo --continuity \
    -O drop \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.log

test_tsp \
    -I file $(fpath "$INFILE") \
    -P filter --every 1000 --set-label 1 \
    -P isdbinfo --except-label 1 --continuity \
    -O drop \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.log

test_tsp \
    -I file $(fpath "$INFILE") \
    -P filter --every 1000 --set-label 1 \
    -P craft --only-label 1 --delete-rs204 \
    -P isdbinfo --continuity --output $(fpath "$OUTDIR/$SCRIPT.3.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.3.log" 2>&1

test_text $SCRIPT.3.log
test_text $SCRIPT.3.txt

test_tsp \
    -I file $(fpath "$INFILE") \
    -P filter --every 1000 --set-label 1 \
    -P isdbinfo --except-label 1 --continuity --output $(fpath "$OUTDIR/$SCRIPT.4.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.4.log" 2>&1

test_text $SCRIPT.4.log
test_text $SCRIPT.4.txt

test_tsp \
    -I file $(fpath "$INFILE") \
    -P isdbinfo --statistics --output $(fpath "$OUTDIR/$SCRIPT.5.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.5.log" 2>&1

test_text $SCRIPT.5.log
test_text $SCRIPT.5.txt

test_tsp \
    -I file $(fpath "$INFILE") \
    -P until --packets 50 \
    -P isdbinfo --trailers --output $(fpath "$OUTDIR/$SCRIPT.6.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.6.log" 2>&1

test_text $SCRIPT.6.log
test_text $SCRIPT.6.txt

test_tsp \
    -I file $(fpath "$INFILE") \
    -P filter --pid 0x1FF0 --set-label 1 \
    -P until --only-label 1 --packets 4 \
    -P isdbinfo --iip --output $(fpath "$OUTDIR/$SCRIPT.7.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.7.log" 2>&1

test_text $SCRIPT.7.log
test_text $SCRIPT.7.txt
