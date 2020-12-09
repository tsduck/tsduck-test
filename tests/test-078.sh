#!/bin/bash
# Options --patch-xml

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INDIR/test-001.ts") \
    -P pat --patch-xml $(fpath "$INDIR/$SCRIPT.xml") \
    -P pmt --pmt-pid 100 --patch-xml $(fpath "$INDIR/$SCRIPT.xml") \
    -P pmt --pmt-pid 200 --patch-xml $(fpath "$INDIR/$SCRIPT.xml") \
    -P pmt --pmt-pid 300 --patch-xml $(fpath "$INDIR/$SCRIPT.xml") \
    -P pmt --pmt-pid 400 --patch-xml $(fpath "$INDIR/$SCRIPT.xml") \
    -P pmt --pmt-pid 500 --patch-xml $(fpath "$INDIR/$SCRIPT.xml") \
    -P pmt --pmt-pid 600 --patch-xml $(fpath "$INDIR/$SCRIPT.xml") \
           --patch-xml '<?xml version="1.0" encoding="UTF-8"?><tsduck><PMT x-update-version="30"/></tsduck>' \
    -P filter --pid 0 --pid 1 --pid 100 --pid 200 --pid 300 --pid 400 --pid 500 --pid 600 \
    -P tables --text $(fpath "$OUTDIR/$SCRIPT.txt") --xml $(fpath "$OUTDIR/$SCRIPT.xml") \
    -O file $(fpath "$OUTDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.txt
test_text $SCRIPT.xml
test_text $SCRIPT.log
test_bin $SCRIPT.ts

