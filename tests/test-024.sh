#!/usr/bin/env bash
# Test continuity plugin.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/$SCRIPT.ts"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P continuity \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1

test_text $SCRIPT.tsp.1.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P continuity --fix \
    -P continuity \
    -O file $(fpath "$OUTDIR/$SCRIPT.out.ts") \
    >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1

test_bin $SCRIPT.out.ts
test_text $SCRIPT.tsp.2.log

$(tspath tsdump) $(fpath "$OUTDIR/$SCRIPT.out.ts") >"$OUTDIR/$SCRIPT.tsdump.txt" 2>"$OUTDIR/$SCRIPT.tsdump.log"

test_text $SCRIPT.tsdump.txt
test_text $SCRIPT.tsdump.log
