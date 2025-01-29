#!/usr/bin/env bash
# Non-regression on scrambler plugin (--only-pid option)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"
ECMG_PORT=31456

$(tspath tsecmg) \
    --once --port $ECMG_PORT \
    >"$OUTDIR/$SCRIPT.tsecmg.log" 2>&1 &

ecmg_pid=$!
sleep 0.5

test_tsp \
    -I file $(fpath "$INFILE") \
    -P until --packet 40,000 \
    -P file $(fpath "$TMPDIR/$SCRIPT.1.ts") \
    -P scrambler 0x2262 --atis-idsa --ecmg $LOCALHOST:$ECMG_PORT --synchronous --super-cas-id 0x12345678 --only-pid 0x00D2 \
    -O file $(fpath "$TMPDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

wait $ecmg_pid

test_text $SCRIPT.tsecmg.log
test_text $SCRIPT.tsp.log

file_size "$TMPDIR/$SCRIPT.1.ts" >"$OUTDIR/$SCRIPT.size.1.log" 2>&1
file_size "$TMPDIR/$SCRIPT.2.ts" >"$OUTDIR/$SCRIPT.size.2.log" 2>&1

test_text $SCRIPT.size.1.log
test_text $SCRIPT.size.2.log

$(tspath tsanalyze) $(fpath "$TMPDIR/$SCRIPT.1.ts") \
    2>"$OUTDIR/$SCRIPT.tsanalyze.1.log" | \
    grep -e 0x00D2 -e 0x00DD -e 0x00DE \
    >"$OUTDIR/$SCRIPT.tsanalyze.1.txt" 2>&1

$(tspath tsanalyze) $(fpath "$TMPDIR/$SCRIPT.2.ts") \
    2>"$OUTDIR/$SCRIPT.tsanalyze.2.log" | \
    grep -e 0x00D2 -e 0x00DD -e 0x00DE \
    >"$OUTDIR/$SCRIPT.tsanalyze.2.txt" 2>&1

test_text $SCRIPT.tsanalyze.1.txt
test_text $SCRIPT.tsanalyze.1.log
test_text $SCRIPT.tsanalyze.2.txt
test_text $SCRIPT.tsanalyze.2.log
