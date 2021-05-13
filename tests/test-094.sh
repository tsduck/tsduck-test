#!/usr/bin/env bash
# svresync plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-092.ts"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --service france2 --service france4 --set-label 0 \
    -P pcrextract --only-label 0 -e -o $(fpath "$OUTDIR/$SCRIPT.1a.csv") \
    -P pcrextract --only-label 0 --pcr -o $(fpath "$OUTDIR/$SCRIPT.1a.pcr.csv") \
    -P pcrextract --only-label 0 --pts -o $(fpath "$OUTDIR/$SCRIPT.1a.pts.csv") \
    -P pcrextract --only-label 0 --dts -o $(fpath "$OUTDIR/$SCRIPT.1a.dts.csv") \
    -P svresync france4 -s france2 \
    -P pcrextract --only-label 0 -e -o $(fpath "$OUTDIR/$SCRIPT.1b.csv") \
    -P pcrextract --only-label 0 --pcr -o $(fpath "$OUTDIR/$SCRIPT.1b.pcr.csv") \
    -P pcrextract --only-label 0 --pts -o $(fpath "$OUTDIR/$SCRIPT.1b.pts.csv") \
    -P pcrextract --only-label 0 --dts -o $(fpath "$OUTDIR/$SCRIPT.1b.dts.csv") \
    -O drop \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1a.csv
test_text $SCRIPT.1a.pcr.csv
test_text $SCRIPT.1a.pts.csv
test_text $SCRIPT.1a.dts.csv
test_text $SCRIPT.1b.csv
test_text $SCRIPT.1b.pcr.csv
test_text $SCRIPT.1b.pts.csv
test_text $SCRIPT.1b.dts.csv
test_text $SCRIPT.1.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --service france2 --service france4 --set-label 0 \
    -P pcrextract --only-label 0 -e -o $(fpath "$OUTDIR/$SCRIPT.2a.csv") \
    -P pcrextract --only-label 0 --pcr -o $(fpath "$OUTDIR/$SCRIPT.2a.pcr.csv") \
    -P pcrextract --only-label 0 --pts -o $(fpath "$OUTDIR/$SCRIPT.2a.pts.csv") \
    -P pcrextract --only-label 0 --dts -o $(fpath "$OUTDIR/$SCRIPT.2a.dts.csv") \
    -P svresync france2 -s france4 \
    -P pcrextract --only-label 0 -e -o $(fpath "$OUTDIR/$SCRIPT.2b.csv") \
    -P pcrextract --only-label 0 --pcr -o $(fpath "$OUTDIR/$SCRIPT.2b.pcr.csv") \
    -P pcrextract --only-label 0 --pts -o $(fpath "$OUTDIR/$SCRIPT.2b.pts.csv") \
    -P pcrextract --only-label 0 --dts -o $(fpath "$OUTDIR/$SCRIPT.2b.dts.csv") \
    -O drop \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2a.csv
test_text $SCRIPT.2a.pcr.csv
test_text $SCRIPT.2a.pts.csv
test_text $SCRIPT.2a.dts.csv
test_text $SCRIPT.2b.csv
test_text $SCRIPT.2b.pcr.csv
test_text $SCRIPT.2b.pts.csv
test_text $SCRIPT.2b.dts.csv
test_text $SCRIPT.2.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --service france2 --service france4 --set-label 0 \
    -P pcrextract --only-label 0 -e -o $(fpath "$OUTDIR/$SCRIPT.3a.csv") \
    -P pcrextract --only-label 0 --pcr -o $(fpath "$OUTDIR/$SCRIPT.3a.pcr.csv") \
    -P pcrextract --only-label 0 --pts -o $(fpath "$OUTDIR/$SCRIPT.3a.pts.csv") \
    -P pcrextract --only-label 0 --dts -o $(fpath "$OUTDIR/$SCRIPT.3a.dts.csv") \
    -P svresync france4 -p 320 \
    -P pcrextract --only-label 0 -e -o $(fpath "$OUTDIR/$SCRIPT.3b.csv") \
    -P pcrextract --only-label 0 --pcr -o $(fpath "$OUTDIR/$SCRIPT.3b.pcr.csv") \
    -P pcrextract --only-label 0 --pts -o $(fpath "$OUTDIR/$SCRIPT.3b.pts.csv") \
    -P pcrextract --only-label 0 --dts -o $(fpath "$OUTDIR/$SCRIPT.3b.dts.csv") \
    -O drop \
    >"$OUTDIR/$SCRIPT.3.log" 2>&1

test_text $SCRIPT.3a.csv
test_text $SCRIPT.3a.pcr.csv
test_text $SCRIPT.3a.pts.csv
test_text $SCRIPT.3a.dts.csv
test_text $SCRIPT.3b.csv
test_text $SCRIPT.3b.pcr.csv
test_text $SCRIPT.3b.pts.csv
test_text $SCRIPT.3b.dts.csv
test_text $SCRIPT.3.log
