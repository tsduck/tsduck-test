#!/bin/bash
# Section filtering using binary masks

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE=

# Get PMT's with even service ids
$(tspath tstables) $(fpath "$INDIR/test-001.ts") \
    --section-content 0200000000 --section-mask FF00000001 \
    --text $(fpath "$OUTDIR/$SCRIPT.1.txt") \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.txt
test_text $SCRIPT.1.log

# Get PMT's with odd service ids
$(tspath tstables) $(fpath "$INDIR/test-001.ts") \
    --section-content 0200000001 --section-mask FF00000001 \
    --text $(fpath "$OUTDIR/$SCRIPT.2.txt") \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.txt
test_text $SCRIPT.2.log

# Insert SCTE-35 cues and select them according to binary patterns on event id.
OPTIONS=(
    ""
    "--section-content FC0000000000000000000000000501020304 --section-mask FF000000000000000000000000FFFFFFFFFF"
    "--section-content FC0000000000000000000000000501020304 --section-mask FF000000000000000000000000FFFFFFFFFF --keep"
    "--section-content FC0000000000000000000000000501020305 --section-content FC0000000000000000000000000501020307 --section-mask FF000000000000000000000000FFFFFFFFFF --keep"
)
for ((i=0; $i<${#OPTIONS[@]}; i++)); do

    $(tspath tsp) --synchronous-log \
        -I null \
        -P inject --pid 100 --inter-packet 100 --stuffing $(fpath "$INDIR/$SCRIPT.xml") \
        -P until --packets 1150 \
        -P sections --pid 100 ${OPTIONS[$i]} \
        -P tables --all-sections --packet-index --text $(fpath "$OUTDIR/$SCRIPT.1$i.txt") \
        -O file $HOME/tmp/foo.ts \
        >"$OUTDIR/$SCRIPT.1$i.log" 2>&1

    test_text $SCRIPT.1$i.txt
    test_text $SCRIPT.1$i.log

done
