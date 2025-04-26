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

test_tsp \
    -I file $(fpath "$INFILE") \
    -P filter --service france2 --set-label 2 \
    -P tables --only-label 2 --tid 2 --text-output $(fpath "$OUTDIR/$SCRIPT.5.pmt1.txt") \
    -P identify --service france2 --video --set-environment-variable VIDEO_PID --all-set-label 3 \
    -P pmt --only-label 3 --service france2 --increment-version \
           --patch-xml $(fpath "$INDIR/$SCRIPT.patch.xml") --expand-patch-xml \
    -P tables --only-label 2 --tid 2 --text-output $(fpath "$OUTDIR/$SCRIPT.5.pmt2.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.5.log" 2>&1

test_text $SCRIPT.5.log
test_text $SCRIPT.5.pmt1.txt
test_text $SCRIPT.5.pmt2.txt
