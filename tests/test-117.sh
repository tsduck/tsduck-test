#!/bin/bash
# Test tscmp

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tsp) --synchronous-log \
    -I null 10 \
    -P inject --pid 100 --inter-packet 2 $(fpath "$INDIR/$SCRIPT.xml") \
    -P pmt --pmt-pid 100 \
    -P tables --xml $(fpath "$OUTDIR/$SCRIPT.1.xml") \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.log
test_text $SCRIPT.1.xml
test_bin $SCRIPT.1.ts

$(tspath tsp) --synchronous-log \
    -I null 10 \
    -P inject --pid 100 --inter-packet 2 $(fpath "$INDIR/$SCRIPT.xml") \
    -P pmt --pmt-pid 100 --sort-pids 0x0102,0x0115,0x0100,0x1234,0x0120 \
    -P tables --xml $(fpath "$OUTDIR/$SCRIPT.2.xml") \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.log
test_text $SCRIPT.2.xml
test_bin $SCRIPT.2.ts

$(tspath tsp) --synchronous-log \
    -I null 10 \
    -P inject --pid 100 --inter-packet 2 $(fpath "$INDIR/$SCRIPT.xml") \
    -P pmt --pmt-pid 100 --sort-languages foo,l06,l03,l05,bar \
    -P tables --xml $(fpath "$OUTDIR/$SCRIPT.3.xml") \
    -O file $(fpath "$OUTDIR/$SCRIPT.3.ts") \
    >"$OUTDIR/$SCRIPT.3.log" 2>&1

test_text $SCRIPT.3.log
test_text $SCRIPT.3.xml
test_bin $SCRIPT.3.ts
