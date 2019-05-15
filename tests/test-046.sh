#!/bin/bash
# Test filter plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --pattern 4A6C --search-payload \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1

test_bin $SCRIPT.1.ts
test_text $SCRIPT.tsp.1.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --pattern 4A6CF2 \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1

test_bin $SCRIPT.2.ts
test_text $SCRIPT.tsp.2.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --pattern 4A6CF200 \
    -O file $(fpath "$OUTDIR/$SCRIPT.3.ts") \
    >"$OUTDIR/$SCRIPT.tsp.3.log" 2>&1

test_bin $SCRIPT.3.ts
test_text $SCRIPT.tsp.3.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --pattern 4A6CF2 --search-offset 0xB8 \
    -O file $(fpath "$OUTDIR/$SCRIPT.4.ts") \
    >"$OUTDIR/$SCRIPT.tsp.4.log" 2>&1

test_bin $SCRIPT.4.ts
test_text $SCRIPT.tsp.4.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --pattern 4A6CF2 --search-payload --search-offset 0xB4 \
    -O file $(fpath "$OUTDIR/$SCRIPT.5.ts") \
    >"$OUTDIR/$SCRIPT.tsp.5.log" 2>&1

test_bin $SCRIPT.5.ts
test_text $SCRIPT.tsp.5.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --pattern 4A6C --search-payload --search-offset 0xB4 \
    -O file $(fpath "$OUTDIR/$SCRIPT.6.ts") \
    >"$OUTDIR/$SCRIPT.tsp.6.log" 2>&1

test_bin $SCRIPT.6.ts
test_text $SCRIPT.tsp.6.log
