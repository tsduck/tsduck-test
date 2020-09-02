#!/bin/bash
# Preserve packet metadata in fork and timeshift

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# We don't store the output file. It is large and should be identical
# to the input one. So, we just store the result of the comparison.
# We use "cmp" instead of "tscmp" to be sure to compare time stamps also.

INFILE="$INDIR/test-065.m2ts"

# M2TS through fork
$(tspath tsp) --synchronous-log \
    -I fork 'cat "'$(fpath "$INFILE")'"' \
    -O file $(fpath "$TMPDIR/$SCRIPT.1.m2ts") --format m2ts \
    >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1

test_text $SCRIPT.tsp.1.log

cmp "$INFILE" "$TMPDIR/$SCRIPT.1.m2ts" >"$OUTDIR/$SCRIPT.cmp.1.log" 2>&1
test_text $SCRIPT.cmp.1.log

# Time-shift
$(tspath tsp) --synchronous-log --add-stop-stuffing 1000 \
    -I file $(fpath "$INFILE") \
    -P filter --every 1000 --set-label 4 \
    -P timeshift --packets 1000 --directory $(fpath "$TMPDIR") --drop-initial \
    -P file --only-label 4 $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    -O file $(fpath "$TMPDIR/$SCRIPT.2.m2ts") --format m2ts \
    >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1

test_text $SCRIPT.tsp.2.log
test_bin $SCRIPT.2.ts

cmp "$INFILE" "$TMPDIR/$SCRIPT.2.m2ts" >"$OUTDIR/$SCRIPT.cmp.2.log" 2>&1
test_text $SCRIPT.cmp.2.log

# TSDuck file format through fork and pipe
$(tspath tsp) --synchronous-log \
    -I fork "$(fpath $(tspath tsp)) -I file "$(fpath "$INFILE")" -P filter --every 1000 --set-label 27 -O file --format duck" \
    -O file --format duck \
    2>"$OUTDIR/$SCRIPT.tsp.3a.log" | \
$(tspath tsp) --synchronous-log \
    -P file --only-label 27 $(fpath "$OUTDIR/$SCRIPT.3.ts") \
    -O file $(fpath "$TMPDIR/$SCRIPT.3.m2ts") --format m2ts \
    >"$OUTDIR/$SCRIPT.tsp.3b.log" 2>&1

test_text $SCRIPT.tsp.3a.log
test_text $SCRIPT.tsp.3b.log
test_bin $SCRIPT.3.ts

cmp "$INFILE" "$TMPDIR/$SCRIPT.3.m2ts" >"$OUTDIR/$SCRIPT.cmp.3.log" 2>&1
test_text $SCRIPT.cmp.3.log
