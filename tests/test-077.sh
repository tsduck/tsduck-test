#!/usr/bin/env bash
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

# Test environment variables.
export TEST_1=AAA
export TEST_2=BBB
export TEST_3=
unset  TEST_4
export TEST_5=CCC

$(tspath tsxml) --strict-xml $(fpath "$INDIR/$SCRIPT.env.xml") \
    --expand-environment \
    --output $(fpath "$OUTDIR/$SCRIPT.env.xml") \
    >"$OUTDIR/$SCRIPT.env.log" 2>&1

test_text $SCRIPT.env.xml
test_text $SCRIPT.env.log
