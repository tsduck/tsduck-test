#!/usr/bin/env bash
# New DVB MJD format for dates after 2038 (from BBC test streams)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

for ((i=1; $i<7; i++)); do

    $(tspath tstables) $(fpath "$INDIR/$SCRIPT.$i.ts") \
        --text-output $(fpath "$OUTDIR/$SCRIPT.$i.txt") \
        >"$OUTDIR/$SCRIPT.$i.log" 2>&1

    test_text $SCRIPT.$i.log
    test_text $SCRIPT.$i.txt

    $(tspath tstabdump) $(fpath "$INDIR/$SCRIPT.$i.eit.bin") \
        >"$OUTDIR/$SCRIPT.$i.eit.txt" \
        2>"$OUTDIR/$SCRIPT.$i.eit.log"

    test_text $SCRIPT.$i.eit.log
    test_text $SCRIPT.$i.eit.txt

done
