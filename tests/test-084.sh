#!/bin/bash
# Options --patch-xml

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P splicemonitor --packet-index \
    -O drop \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P splicemonitor --packet-index --display-commands -o $(fpath "$OUTDIR/$SCRIPT.2.txt") \
    -P splicemonitor --all-commands --splice-pid 1055 -o $(fpath "$OUTDIR/$SCRIPT.3.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.log
test_text $SCRIPT.2.txt
test_text $SCRIPT.3.txt
