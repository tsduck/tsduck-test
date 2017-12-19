#!/bin/bash
# Test tspacketize

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INXML="$INDIR/test-006.xml"
INBIN="$INDIR/test-006.bin"

$(tspath tspacketize) $(fpath "$INBIN") $(fpath "$INXML") --pid 200 --output $(fpath "$OUTDIR/$SCRIPT.pack.ts") \
    2>"$OUTDIR/$SCRIPT.pack.log" 2>&1

test_bin $SCRIPT.pack.ts
test_text $SCRIPT.pack.log
