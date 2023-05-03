#!/usr/bin/env bash
# Test timeshift plugin.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I craft --pid 100 --payload-pattern DEADBEEF \
    -P until --packets 30 \
    -P timeshift --packets 10 \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_bin $SCRIPT.1.ts
test_text $SCRIPT.1.log

$(tspath tsdump) $(fpath "$OUTDIR/$SCRIPT.1.ts") >"$OUTDIR/$SCRIPT.tsdump.1.txt" 2>"$OUTDIR/$SCRIPT.tsdump.1.log"

test_text $SCRIPT.tsdump.1.txt
test_text $SCRIPT.tsdump.1.log

test_tsp --bitrate 20,000 \
    -I craft --pid 100 --payload-pattern DEADBEEF \
    -P until --packets 30 \
    -P timeshift --time 1000 --drop-initial \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_bin $SCRIPT.2.ts
test_text $SCRIPT.2.log

$(tspath tsdump) $(fpath "$OUTDIR/$SCRIPT.2.ts") >"$OUTDIR/$SCRIPT.tsdump.2.txt" 2>"$OUTDIR/$SCRIPT.tsdump.2.log"

test_text $SCRIPT.tsdump.2.txt
test_text $SCRIPT.tsdump.2.log
