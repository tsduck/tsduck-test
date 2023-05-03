#!/usr/bin/env bash
# Test adding CA descriptors in PAT and PMT.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"
PMTPID=0x03E8

test_tsp \
    -I file $(fpath "$INFILE") \
    -P cat --add-ca 0x1234/7000/0123456789 --add-ca 0x5678/7001/456789 \
    -P pmt --pmt-pid $PMTPID --add-ca 0xCAFE/7002/DEADBEEF --add-ca 0xF000/7003/BADCAFEE \
    -P until --packets 4000 \
    -O file $(fpath "$OUTDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_bin $SCRIPT.ts
test_text $SCRIPT.tsp.log

$(tspath tstables) $(fpath "$OUTDIR/$SCRIPT.ts") \
    --pid 1 --pid $PMTPID \
    --text-output $(fpath "$OUTDIR/$SCRIPT.txt") \
    --binary-output $(fpath "$OUTDIR/$SCRIPT.bin") \
    --xml-output $(fpath "$OUTDIR/$SCRIPT.xml") \
    >"$OUTDIR/$SCRIPT.tstables.log" 2>&1

test_bin $SCRIPT.bin
test_text $SCRIPT.txt
test_text $SCRIPT.xml
test_text $SCRIPT.tstables.log
