#!/usr/bin/env bash
# Plugin identify

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
INFILE="$INDIR/test-092.ts"

test_tsp \
    -I file $(fpath "$INFILE") \
    -P identify --pmt \
    -O drop \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.log

test_tsp \
    -I file $(fpath "$INFILE") \
    -P identify --service france2 --set-label 3 --log \
    -P count --only-label 3 \
    -O drop \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.log

test_tsp \
    -I file $(fpath "$INFILE") \
    -P identify --service france4 --audio --language fre \
    -O drop \
    >"$OUTDIR/$SCRIPT.3.log" 2>&1

test_text $SCRIPT.3.log

test_tsp \
    -I file $(fpath "$INFILE") \
    -P identify --subtitles --language fra \
    -O drop \
    >"$OUTDIR/$SCRIPT.4.log" 2>&1

test_text $SCRIPT.4.log
