#!/bin/bash
# Tests for "tsxml" utility with options --merge and --sort.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

infiles=()
for file in "$INDIR"/$SCRIPT.*.xml; do
    infiles+=($(fpath "$file"))
done

$(tspath tsxml) --strict-xml \
    --merge "${infiles[@]}" \
    --sort _tables --sort _descriptors \
    --uncomment \
    --output $(fpath "$OUTDIR/$SCRIPT.out.xml") \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.out.xml
test_text $SCRIPT.log
