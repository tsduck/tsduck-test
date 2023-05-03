#!/usr/bin/env bash
# Inject plugin with repetition rates.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"
TABLE1="$INDIR/$SCRIPT.1.xml"
TABLE2="$INDIR/$SCRIPT.2.xml"
TABLE3="$INDIR/$SCRIPT.3.xml"
TABLE4="$INDIR/$SCRIPT.4.xml"
TABLE5="$INDIR/$SCRIPT.5.xml"

test_tsp \
    -I file $(fpath "$INFILE") \
    -P svremove 0x2261 --stuffing \
    -P pmt --pmt-pid 0x1003 --add-pid 0x1800/0x05 --add-pid 0x1801/0x05 --add-pid 0x1802/0x05 \
    -P inject $(fpath "$TABLE1") $(fpath "$TABLE2")=100 --pid 0x1800 --bitrate 30,000 --stuffing \
    -P inject $(fpath "$TABLE3")=200 $(fpath "$TABLE4")=300 --pid 0x1801 --stuffing \
    -P inject $(fpath "$TABLE5")=100 --pid 0x1802 --stuffing \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.analyze.out.txt") \
    -P tables --pid 0x1800 --pid 0x1801 --pid 0x1802  -o $(fpath "$OUTDIR/$SCRIPT.tables.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.out.ts") \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_bin $SCRIPT.out.ts
test_text $SCRIPT.analyze.out.txt
test_text $SCRIPT.tables.txt
test_text $SCRIPT.tsp.log
