#!/usr/bin/env bash
# pcrcopy plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-092.ts"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P svremove 0x0105 --stuffing \
    -P pcrcopy --reference-pid 620 --target-pid 630 \
    -P pcrextract --pid 620-630 --pcr --csv -o $(fpath "$OUTDIR/$SCRIPT.1.csv") \
    -P zap 0x0106 \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_bin $SCRIPT.1.ts
test_text $SCRIPT.1.csv
test_text $SCRIPT.1.log
