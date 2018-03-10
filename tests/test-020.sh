#!/bin/bash
# Test pmt plugin
# Output TS contains only PAT and PMT's to reduce its size

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P pmt -p 100 --remove-descriptor 9 --add-ca-descriptor 0x100/123/01234567 \
    -P pmt -p 200 --remove-descriptor 9 --add-pid 0x1111/0x0D --set-data-broadcast-id 0x1111/11/0600000401E3 \
    -P pmt -p 300 --remove-descriptor 9 --add-stream-identifier \
    -P pmt -p 400 --remove-descriptor 9 \
    -P pmt -p 500 --remove-descriptor 9 --set-stream-identifier 510/3 --set-stream-identifier 521/123 \
    -P pmt -p 600 --remove-descriptor 9 --set-cue-type 610/1 --set-cue-type 621/2 --remove-pid 622 \
    -P pmt -p 700 --remove-descriptor 9 \
    -P pmt -p 800 --remove-descriptor 9 \
    -P pmt -p 900 --remove-descriptor 9 \
    -P pmt -p 1000 --remove-descriptor 9 \
    -P pmt -p 0x1003 --remove-descriptor 9 \
    -P sifilter --pat --pmt \
    -P psi -o $(fpath "$OUTDIR/$SCRIPT.psi.txt") \
    -P tables --text $(fpath "$OUTDIR/$SCRIPT.tables.txt") --bin $(fpath "$OUTDIR/$SCRIPT.tables.bin") \
    -O file $(fpath "$OUTDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_bin $SCRIPT.ts
test_bin $SCRIPT.tables.bin
test_text $SCRIPT.tables.txt
test_text $SCRIPT.psi.txt
test_text $SCRIPT.tsp.log
