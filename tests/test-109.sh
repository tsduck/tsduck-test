#!/bin/bash
# Non-regression test for packets without payload in t2mi plugin (issue #950)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P t2mi --pid 0x1000 \
    -O file $(fpath "$OUTDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.log
test_bin $SCRIPT.ts
