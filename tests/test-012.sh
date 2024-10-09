#!/usr/bin/env bash
# Test Teletext, French language.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
source "$COMMONDIR"/standard-ts-test.sh $SCRIPT.ts

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P teletext -o $(fpath "$OUTDIR/$SCRIPT.srt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.teletext.log" 2>&1

test_text $SCRIPT.teletext.log
test_text $SCRIPT.srt
