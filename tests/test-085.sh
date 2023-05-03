#!/usr/bin/env bash
# Test http plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I http https://tsduck.io/streams/usa-atsc/473.ts \
    -P until --packets 1000 \
    -O file $(fpath "$OUTDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_bin $SCRIPT.ts
test_text $SCRIPT.log
