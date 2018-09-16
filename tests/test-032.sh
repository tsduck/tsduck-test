#!/bin/bash
# Test DSM-CC stream events from http://tv-html.irt.de/hbbtv/tests/streamevent/

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

function testfile
{
    local num=$1
    local pid=$2

    $(tspath tstables) $(fpath "$INDIR/$SCRIPT.$num.ts") \
                       --all-sections --pack-all-sections \
                       --bin $(fpath "$OUTDIR/$SCRIPT.$num.bin") \
                       --text $(fpath "$OUTDIR/$SCRIPT.$num.txt") \
                       --xml $(fpath "$OUTDIR/$SCRIPT.$num.xml") \
                       >"$OUTDIR/$SCRIPT.tstables.$num.log" 2>&1

    test_bin $SCRIPT.$num.bin
    test_text $SCRIPT.$num.txt
    test_text $SCRIPT.$num.xml
    test_text $SCRIPT.tstables.$num.log

    $(tspath tspacketize) $(fpath "$OUTDIR/$SCRIPT.$num.xml") \
                          --pid $pid --stuffing \
                          --out $(fpath "$OUTDIR/$SCRIPT.$num.ts") \
                          >"$OUTDIR/$SCRIPT.tspacketize.$num.log" 2>&1

    test_bin $SCRIPT.$num.ts
    test_text $SCRIPT.tspacketize.$num.log

    $(tspath tstables) $(fpath "$OUTDIR/$SCRIPT.$num.ts") \
                       --all-sections --pack-all-sections \
                       --bin $(fpath "$OUTDIR/$SCRIPT.out.$num.bin") \
                       --text $(fpath "$OUTDIR/$SCRIPT.out.$num.txt") \
                       --xml $(fpath "$OUTDIR/$SCRIPT.out.$num.xml") \
                       >"$OUTDIR/$SCRIPT.tstables.out.$num.log" 2>&1

    test_bin $SCRIPT.out.$num.bin
    test_text $SCRIPT.out.$num.txt
    test_text $SCRIPT.out.$num.xml
    test_text $SCRIPT.tstables.out.$num.log

    (
        diff "$OUTDIR/$SCRIPT.$num.txt" "$OUTDIR/$SCRIPT.out.$num.txt"
        diff "$OUTDIR/$SCRIPT.$num.xml" "$OUTDIR/$SCRIPT.out.$num.xml"
    ) >"$OUTDIR/$SCRIPT.cmp.$num.log" 2>&1

    test_text $SCRIPT.cmp.$num.log
}

testfile 1 0x0194
testfile 2 0x0FA2
