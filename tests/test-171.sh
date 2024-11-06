#!/usr/bin/env bash
# Test packet trailers in a 204-byte ISDB-Tb live stream

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-170.ts"

test_tsp \
    -I file $(fpath "$INFILE") \
    -P until --packets 200 \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") --format rs204 \
    >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1

test_text $SCRIPT.tsp.1.log
test_bin $SCRIPT.1.ts

test_tsp \
    -I file $(fpath "$INFILE") \
    -P until --packets 200 \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") --format ts \
    >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1

test_text $SCRIPT.tsp.2.log
test_bin $SCRIPT.2.ts

$(tspath tsdump) --max-packets 20 --rs204 --isdb \
    $(fpath "$INFILE") \
    >$(fpath "$OUTDIR/$SCRIPT.3.txt") \
    2>"$OUTDIR/$SCRIPT.tsdump.3.log"

test_text $SCRIPT.tsdump.3.log
test_text $SCRIPT.3.txt

$(tspath tsdump) --max-packets 20 --rs204 --isdb \
    $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >$(fpath "$OUTDIR/$SCRIPT.4.txt") \
    2>"$OUTDIR/$SCRIPT.tsdump.4.log"

test_text $SCRIPT.tsdump.4.log
test_text $SCRIPT.4.txt

$(tspath tsdump) --max-packets 20 --rs204 --isdb \
    $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >$(fpath "$OUTDIR/$SCRIPT.5.txt") \
    2>"$OUTDIR/$SCRIPT.tsdump.5.log"

test_text $SCRIPT.tsdump.5.log
test_text $SCRIPT.5.txt
