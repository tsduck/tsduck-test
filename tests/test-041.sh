#!/usr/bin/env bash
# Test tsfixcc and continuity plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/$SCRIPT.ts"

# CC values in input file (index:cc:
# PID 123:
#   0:7 1:8 2:2 (+disc.ind.) 3:3 4:4 5:5 6:6 7:7 8:7 9:7 10:8 11:3 12:4 13:5 14:5 15:6
# PID 100:
#   16:5 17:6 18:6 (no pl) 19:6 (no pl) 20:7 (no pl)

cp "$INFILE" "$OUTDIR/$SCRIPT.tsfixcc.1.ts"
$(tspath tsfixcc) "$OUTDIR/$SCRIPT.tsfixcc.1.ts" \
    --verbose --noaction >"$OUTDIR/$SCRIPT.tsfixcc.1.log" 2>&1

test_bin $SCRIPT.tsfixcc.1.ts
test_text $SCRIPT.tsfixcc.1.log

$(tspath tsdump) "$OUTDIR/$SCRIPT.tsfixcc.1.ts" \
    >"$OUTDIR/$SCRIPT.tsfixcc.1.tsdump.txt" \
    2>"$OUTDIR/$SCRIPT.tsfixcc.1.tsdump.log"

test_text $SCRIPT.tsfixcc.1.tsdump.txt
test_text $SCRIPT.tsfixcc.1.tsdump.log

cp "$INFILE" "$OUTDIR/$SCRIPT.tsfixcc.2.ts"
$(tspath tsfixcc) "$OUTDIR/$SCRIPT.tsfixcc.2.ts" \
    --verbose >"$OUTDIR/$SCRIPT.tsfixcc.2.log" 2>&1

test_bin $SCRIPT.tsfixcc.2.ts
test_text $SCRIPT.tsfixcc.2.log

$(tspath tsdump) "$OUTDIR/$SCRIPT.tsfixcc.2.ts" \
    >"$OUTDIR/$SCRIPT.tsfixcc.2.tsdump.txt" \
    2>"$OUTDIR/$SCRIPT.tsfixcc.2.tsdump.log"

test_text $SCRIPT.tsfixcc.2.tsdump.txt
test_text $SCRIPT.tsfixcc.2.tsdump.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P continuity --tag first \
    -P file $(fpath "$OUTDIR/$SCRIPT.tsp.1.ts") \
    -P continuity --tag second --fix \
    -O file $(fpath "$OUTDIR/$SCRIPT.tsp.2.ts") \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_bin $SCRIPT.tsp.1.ts
test_bin $SCRIPT.tsp.2.ts
test_text $SCRIPT.tsp.log

$(tspath tsdump) "$OUTDIR/$SCRIPT.tsp.1.ts" \
    >"$OUTDIR/$SCRIPT.tsp.1.tsdump.txt" \
    2>"$OUTDIR/$SCRIPT.tsp.1.tsdump.log"

test_text $SCRIPT.tsp.1.tsdump.txt
test_text $SCRIPT.tsp.1.tsdump.log

$(tspath tsdump) "$OUTDIR/$SCRIPT.tsp.2.ts" \
    >"$OUTDIR/$SCRIPT.tsp.2.tsdump.txt" \
    2>"$OUTDIR/$SCRIPT.tsp.2.tsdump.log"

test_text $SCRIPT.tsp.2.tsdump.txt
test_text $SCRIPT.tsp.2.tsdump.log
