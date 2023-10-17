#!/usr/bin/env bash
# Test option --flush-last-unbounded-pes in plugin pes

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I file $(fpath "$INDIR/test-092.ts") \
    -P until --packets 1500 \
    -P pes --pid 0x78 --packet-index --header \
    -O drop \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.log

test_tsp \
    -I file $(fpath "$INDIR/test-092.ts") \
    -P until --packets 1500 \
    -P pes --pid 0x78 --packet-index --header --flush-last-unbounded-pes \
    -O drop \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.log
