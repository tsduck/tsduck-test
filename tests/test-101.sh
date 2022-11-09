#!/usr/bin/env bash
# Non-regression on DuckContext not correctly passed from `tsp` to plugins tables and psi

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tsp) --japan --synchronous-log \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P tables -t 0x40 -o $(fpath "$OUTDIR/$SCRIPT.tables.txt") \
    -P psi -a -o $(fpath "$OUTDIR/$SCRIPT.psi.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.tables.txt
test_text $SCRIPT.psi.txt
test_text $SCRIPT.log
