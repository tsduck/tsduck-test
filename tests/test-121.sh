#!/bin/bash
# Basic usage of ``tscrc32

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tscrc32) --data '70 00 05 E9 C4 15 33 27' \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.log

$(tspath tscrc32) \
    $(fpath "$INDIR/$SCRIPT.1.bin") \
    $(fpath "$INDIR/$SCRIPT.2.bin") \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.log
