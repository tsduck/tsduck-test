#!/usr/bin/env bash
# Non-regression on tsanalyze, pes and other plugins (assertion failure, issue #797)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tsanalyze) $(fpath "$INDIR/$SCRIPT.ts") >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P pes --pid 120 --h26x-default-format avc --avc-access-unit --header -o $(fpath "$OUTDIR/$SCRIPT.2.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.txt
test_text $SCRIPT.2.log
