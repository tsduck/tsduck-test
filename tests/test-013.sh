#!/bin/bash
# Test Teletext, Russian language.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-013.ts"
source "$COMMONDIR"/standard-ts-test.sh test-013.ts

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P teletext -o $(fpath "$OUTDIR/$SCRIPT.srt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.teletext.log" 2>&1

test_text $SCRIPT.teletext.log
test_text $SCRIPT.srt
