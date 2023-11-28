#!/usr/bin/env bash
# Plugin t2mi

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P t2mi \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.log
test_bin $SCRIPT.1.ts

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P t2mi --output-file $(fpath "$OUTDIR/$SCRIPT.ext.ts") --t2mi-file $(fpath "$OUTDIR/$SCRIPT.ext.t2mi") \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.log
test_bin $SCRIPT.2.ts
test_bin $SCRIPT.ext.ts
test_bin $SCRIPT.ext.t2mi
