#!/usr/bin/env bash
# Non-regression on corrupted HEVC stream (issue #1407)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
INFILE=

$(tspath tsanalyze) $(fpath "$INDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.log

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P pes \
    -O drop \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.log
