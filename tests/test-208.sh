#!/usr/bin/env bash
# Non-regression on ISDB_terrestrial_delivery_system_descriptor (issue #1733)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

for n in 1 2; do

    $(tspath tstables) $(fpath "$INDIR/$SCRIPT.$n.ts") \
        --xml-output $(fpath "$OUTDIR/$SCRIPT.$n.in.xml") \
        >"$OUTDIR/$SCRIPT.$n.in.xml.log" 2>&1

    test_text $SCRIPT.$n.in.xml.log
    test_text $SCRIPT.$n.in.xml

    $(tspath tspacketize) $(fpath "$OUTDIR/$SCRIPT.$n.in.xml") \
        --pid 16 --output $(fpath "$OUTDIR/$SCRIPT.$n.out.ts") \
        >"$OUTDIR/$SCRIPT.$n.out.ts.log" 2>&1

    test_text $SCRIPT.$n.out.ts.log
    test_bin $SCRIPT.$n.out.ts

    $(tspath tstables) $(fpath "$OUTDIR/$SCRIPT.$n.out.ts") \
        --xml-output $(fpath "$OUTDIR/$SCRIPT.$n.out.xml") \
        >"$OUTDIR/$SCRIPT.$n.out.xml.log" 2>&1

    test_text $SCRIPT.$n.out.xml.log
    test_text $SCRIPT.$n.out.xml

done
