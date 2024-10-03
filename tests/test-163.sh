#!/usr/bin/env bash
# Conditions in XML patch files

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tsxml) $(fpath "$INDIR/$SCRIPT.data.1.xml") \
    --patch $(fpath "$INDIR/$SCRIPT.patch.1.xml") \
    --output $(fpath "$OUTDIR/$SCRIPT.out.1.xml") \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.out.1.xml
test_text $SCRIPT.1.log
