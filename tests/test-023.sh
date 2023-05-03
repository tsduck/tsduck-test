#!/usr/bin/env bash
# Test file input plugin with more than one file.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/$SCRIPT"

test_tsp \
    -I file $(fpath "${INFILE}a.ts") $(fpath "${INFILE}b.ts") $(fpath "${INFILE}c.ts") \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1

test_bin $SCRIPT.1.ts
test_text $SCRIPT.tsp.1.log

$(tspath tsdump) $(fpath "$OUTDIR/$SCRIPT.1.ts") >"$OUTDIR/$SCRIPT.tsdump.1.txt" 2>"$OUTDIR/$SCRIPT.tsdump.1.log"

test_text $SCRIPT.tsdump.1.txt
test_text $SCRIPT.tsdump.1.log

test_tsp \
    -I file --repeat 2 $(fpath "${INFILE}a.ts") $(fpath "${INFILE}b.ts") $(fpath "${INFILE}c.ts") \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1

test_bin $SCRIPT.2.ts
test_text $SCRIPT.tsp.2.log

$(tspath tsdump) $(fpath "$OUTDIR/$SCRIPT.2.ts") >"$OUTDIR/$SCRIPT.tsdump.2.txt" 2>"$OUTDIR/$SCRIPT.tsdump.2.log"

test_text $SCRIPT.tsdump.2.txt
test_text $SCRIPT.tsdump.2.log
