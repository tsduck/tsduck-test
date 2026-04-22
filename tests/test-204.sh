#!/usr/bin/env bash
# Non-regression on ATSC service_location_descriptor (issue #1705)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tstabdump) $(fpath "$INDIR/$SCRIPT.bin") \
    >"$OUTDIR/$SCRIPT.txt" \
    2>"$OUTDIR/$SCRIPT.log"

test_text $SCRIPT.log
test_text $SCRIPT.txt
