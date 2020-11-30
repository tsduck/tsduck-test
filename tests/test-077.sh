#!/bin/bash
# Tests for "tsxml" utility.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Process all unitary patches.
for file in "$INDIR"/$SCRIPT.*.in.xml; do

    base=$(basename "$file" .in.xml)
    $(tspath tsxml) --strict-xml $(fpath "$file") \
        --patch $(fpath "$INDIR/$base.patch.xml") \
        --output $(fpath "$OUTDIR/$base.out.xml") \
        >"$OUTDIR/$base.log" 2>&1

    test_text $base.out.xml
    test_text $base.log

done
