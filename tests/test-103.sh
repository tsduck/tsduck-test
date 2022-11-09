#!/usr/bin/env bash
# tspsi with duplicated PMT after PAT change (issue #865)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tspsi) -a $(fpath "$INDIR/$SCRIPT.ts") -o $(fpath "$OUTDIR/$SCRIPT.txt") >"$OUTDIR/$SCRIPT.log" 2>&1
test_text $SCRIPT.txt
test_text $SCRIPT.log
