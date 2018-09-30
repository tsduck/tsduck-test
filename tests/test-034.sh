#!/bin/bash
# Basic tests on tsswitch.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE1="$INDIR/test-023a.ts"
INFILE2="$INDIR/test-023b.ts"
INFILE3="$INDIR/test-023c.ts"

# Simple file concatenation.
$(tspath tsswitch) --synchronous-log \
    -I file $(fpath "$INFILE1") \
    -I file $(fpath "$INFILE2") \
    -I file $(fpath "$INFILE3") \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_bin $SCRIPT.1.ts
test_text $SCRIPT.1.log

# Same with two cycles.
$(tspath tsswitch) --synchronous-log --cycle 2 \
    -I file $(fpath "$INFILE1") \
    -I file $(fpath "$INFILE2") \
    -I file $(fpath "$INFILE3") \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_bin $SCRIPT.2.ts
test_text $SCRIPT.2.log
