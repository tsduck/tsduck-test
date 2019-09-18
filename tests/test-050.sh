#!/bin/bash
# Test SCTE 18 (Emergency Alert System) signalization

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Test of various combinations of tables.
source "$COMMONDIR"/standard-si-test.sh $SCRIPT.xml

# Test of two real-world EAS tables.
testeas()
{
    local file=$SCRIPT.$1

    $(tspath tstables) $(fpath "$INDIR/$file.ts") \
        --text "$OUTDIR/$file.tstables.txt" \
        --xml "$OUTDIR/$file.tstables.xml" \
        --bin "$OUTDIR/$file.tstables.bin" \
        &>"$OUTDIR/$file.tstables.log"

    test_bin $file.tstables.bin
    test_text $file.tstables.txt
    test_text $file.tstables.xml
    test_text $file.tstables.log
}

testeas eas1
testeas eas2
