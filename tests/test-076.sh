#!/usr/bin/env bash
# "file" plugin with start/stop stuffing

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INDIR/$SCRIPT.1.ts") $(fpath "$INDIR/$SCRIPT.2.ts") $(fpath "$INDIR/$SCRIPT.3.ts") \
            --add-start-stuffing 1 --add-start-stuffing 2 \
            --add-stop-stuffing 3 \
            --repeat 2 \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_bin $SCRIPT.1.ts
test_text $SCRIPT.1.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INDIR/$SCRIPT.1.ts") \
    -P file $(fpath "$OUTDIR/$SCRIPT.2.ts") --add-start-stuffing 1 --add-stop-stuffing 2 \
    -O file $(fpath "$OUTDIR/$SCRIPT.3.ts") --add-start-stuffing 3 --add-stop-stuffing 4 \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_bin $SCRIPT.2.ts
test_bin $SCRIPT.3.ts
test_text $SCRIPT.2.log
