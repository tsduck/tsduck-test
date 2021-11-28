#!/bin/bash
# Test duplicate packets with continuity plugin.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Build a crafted input file with specific sequences of packets.
(
    # CC 1-4
    $(tspath tsp) --synchronous-log -I craft --pid 100 --cc 1 --count 4 --payload-pattern 0123
    # CC 4, true duplicate, no AF
    $(tspath tsp) --synchronous-log -I craft --pid 100 --cc 4 --count 1 --payload-pattern 0123
    # CC 5-6
    $(tspath tsp) --synchronous-log -I craft --pid 100 --cc 5 --count 2 --payload-pattern 0123
    # CC 6, false duplicate, no AF
    $(tspath tsp) --synchronous-log -I craft --pid 100 --cc 6 --count 1 --payload-pattern 4567
    # CC 7-8
    $(tspath tsp) --synchronous-log -I craft --pid 100 --cc 7 --count 2 --payload-pattern 0123
    # CC 9, PCR
    $(tspath tsp) --synchronous-log -I craft --pid 100 --cc 9 --count 1 --payload-pattern 0123 --pcr 123456 --private-data 1478
    # CC 9, true duplicate, distinct PCR, same AF
    $(tspath tsp) --synchronous-log -I craft --pid 100 --cc 9 --count 1 --payload-pattern 0123 --pcr 123789 --private-data 1478
    # CC 10-12
    $(tspath tsp) --synchronous-log -I craft --pid 100 --cc 10 --count 3 --payload-pattern 0123
    # CC 13, PCR
    $(tspath tsp) --synchronous-log -I craft --pid 100 --cc 13 --count 1 --payload-pattern 6541 --pcr 123456 --private-data 1478
    # CC 13, true duplicate, distinct PCR, distinct AF, same payload
    $(tspath tsp) --synchronous-log -I craft --pid 100 --cc 13 --count 1 --payload-pattern 6541 --pcr 123789 --private-data 8523
    # CC 14-0
    $(tspath tsp) --synchronous-log -I craft --pid 100 --cc 14 --count 3 --payload-pattern 6541
) >"$OUTDIR/$SCRIPT.in.ts" 2>"$OUTDIR/$SCRIPT.in.log"

test_bin $SCRIPT.in.ts
test_text $SCRIPT.in.log

$(tspath tsdump) $(fpath "$OUTDIR/$SCRIPT.in.ts") >"$OUTDIR/$SCRIPT.tsdump.in.txt" 2>"$OUTDIR/$SCRIPT.tsdump.in.log"

test_text $SCRIPT.tsdump.in.txt
test_text $SCRIPT.tsdump.in.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$OUTDIR/$SCRIPT.in.ts") \
    -P continuity \
    -P continuity --fix \
    -P continuity \
    -O file $(fpath "$OUTDIR/$SCRIPT.out.ts") \
    >"$OUTDIR/$SCRIPT.out.log" 2>&1

test_bin $SCRIPT.out.ts
test_text $SCRIPT.out.log

$(tspath tsdump) $(fpath "$OUTDIR/$SCRIPT.out.ts") >"$OUTDIR/$SCRIPT.tsdump.out.txt" 2>"$OUTDIR/$SCRIPT.tsdump.out.log"

test_text $SCRIPT.tsdump.out.txt
test_text $SCRIPT.tsdump.out.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P continuity --fix \
    -O file $(fpath "$OUTDIR/$SCRIPT.tsp.rep.ts") \
    >"$OUTDIR/$SCRIPT.tsp.rep.log" 2>&1

test_bin $SCRIPT.tsp.rep.ts
test_text $SCRIPT.tsp.rep.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P continuity --fix --no-replicate-duplicated \
    -O file $(fpath "$OUTDIR/$SCRIPT.tsp.norep.ts") \
    >"$OUTDIR/$SCRIPT.tsp.norep.log" 2>&1

test_bin $SCRIPT.tsp.norep.ts
test_text $SCRIPT.tsp.norep.log

cp "$INDIR/$SCRIPT.ts" "$OUTDIR/$SCRIPT.tsfixcc.rep.ts"
$(tspath tsfixcc) "$OUTDIR/$SCRIPT.tsfixcc.rep.ts" \
    >"$OUTDIR/$SCRIPT.tsfixcc.rep.log" 2>&1

test_bin $SCRIPT.tsfixcc.rep.ts
test_text $SCRIPT.tsfixcc.rep.log

cp "$INDIR/$SCRIPT.ts" "$OUTDIR/$SCRIPT.tsfixcc.norep.ts"
$(tspath tsfixcc) "$OUTDIR/$SCRIPT.tsfixcc.norep.ts" --no-replicate-duplicated \
    >"$OUTDIR/$SCRIPT.tsfixcc.norep.log" 2>&1

test_bin $SCRIPT.tsfixcc.norep.ts
test_text $SCRIPT.tsfixcc.norep.log
