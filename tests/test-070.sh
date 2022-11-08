#!/usr/bin/env bash
# Non-regression on fork packet processor plugin (issue #633)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# We don't store the output file. It is large and should be identical
# to the input one. So, we just store the result of the comparison.

INFILE="$INDIR/test-001.ts"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P fork "$(fpath $(tspath tsp)) -O file \""$(fpath "$TMPDIR/$SCRIPT.1.ts")"\"" \
    -O file $(fpath "$TMPDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_text $SCRIPT.tsp.log

cmp "$INFILE" "$TMPDIR/$SCRIPT.1.ts" >"$OUTDIR/$SCRIPT.cmp.1.log" 2>&1
test_text $SCRIPT.cmp.1.log

cmp "$INFILE" "$TMPDIR/$SCRIPT.2.ts" >"$OUTDIR/$SCRIPT.cmp.2.log" 2>&1
test_text $SCRIPT.cmp.2.log
