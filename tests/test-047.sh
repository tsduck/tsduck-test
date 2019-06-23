#!/bin/bash
# Test remap plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P until --packets 50,000 \
    -P remap 0x0060-0x007F=0x1E60 --set-label 30 \
    -P count --only-label 30 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.1.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_bin $SCRIPT.1.ts
test_text $SCRIPT.1.txt
test_text $SCRIPT.1.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P until --packets 50,000 \
    -P remap 0x0060-0x007F=0x1E60 --set-label 30 --unchecked --no-psi --single \
    -P count --only-label 30 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.2.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_bin $SCRIPT.2.ts
test_text $SCRIPT.2.txt
test_text $SCRIPT.2.log
