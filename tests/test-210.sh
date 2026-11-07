#!/usr/bin/env bash
# Plugin t2mi: TS extraction from PLP's with null packet deletion, in High Efficiency Mode
# and in Normal Mode with ISSY (issue #1759). Synthetic single-PLP T2-MI streams.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# 1: HEM with null packet deletion. 2: Normal Mode with 3-byte ISSY and null packet deletion.
# The deleted null packets are reinserted, so the extracted TS is larger than the T2-MI TS
# and --output-file is used instead of the replace mode.
for n in 1 2; do
    test_tsp -I file $(fpath "$INDIR/$SCRIPT.$n.ts") \
        -P t2mi --pid 0x1000 --plp 0 --log --extract --output-file $(fpath "$OUTDIR/$SCRIPT.$n.extracted.ts") \
        -O drop \
        >"$OUTDIR/$SCRIPT.$n.log" 2>&1
    test_text $SCRIPT.$n.log
    test_bin $SCRIPT.$n.extracted.ts
done
