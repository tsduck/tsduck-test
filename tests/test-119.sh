#!/usr/bin/env bash
# Non-regression on scrambler plugin (issue #1070)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-089.ts"
ECMG_PORT=31456
TSP_CMD_PORT=31457
TSP_SEND_PORT=31458

$(tspath tsecmg) \
    --once --port $ECMG_PORT \
    >"$OUTDIR/$SCRIPT.tsecmg.log" 2>&1 &

ecmg_pid=$!
sleep 0.5

test_tsp --control-port $TSP_CMD_PORT --control-reuse-port --add-input-stuffing 1/10 \
    -I file $(fpath "$INFILE") \
    -P regulate \
    -P filter --pid 0x0140 --set-label 1 \
    -P craft --only-label 1 --payload-pattern DEADBEEF --no-repeat \
    -O ip localhost:$TSP_SEND_PORT \
    >"$OUTDIR/$SCRIPT.sender.log" 2>&1 &

sender_pid=$!

test_tsp \
    -I ip $TSP_SEND_PORT --receive-timeout 2000 \
    -P until --packet 40,000 \
    -P scrambler 0x0407 --atis-idsa --ecmg localhost:$ECMG_PORT --super-cas-id 0x12345678 \
    -P filter --pattern DEADBEEF --set-label 1 \
    -P file --only-label 1 $(fpath "$TMPDIR/$SCRIPT.1.ts") \
    -P descrambler 0x0407 \
    -P filter --pattern DEADBEEF \
    -P until --packet 2 \
    -O file $(fpath "$TMPDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

$(tspath tspcontrol) --tsp localhost:$TSP_CMD_PORT exit \
    >"$OUTDIR/$SCRIPT.tspcontrol.log" 2>&1

wait $ecmg_pid $sender_pid

sed -i -e 's|bitrate now known, [0-9,]* b/s,|bitrate now known, xx b/s,|' "$OUTDIR/$SCRIPT.tsp.log"

test_text $SCRIPT.tsecmg.log
test_text $SCRIPT.sender.log
test_text $SCRIPT.tsp.log
test_text $SCRIPT.tspcontrol.log

file_size "$TMPDIR/$SCRIPT.1.ts" >"$OUTDIR/$SCRIPT.size.1.log" 2>&1
file_size "$TMPDIR/$SCRIPT.2.ts" >"$OUTDIR/$SCRIPT.size.2.log" 2>&1

test_text $SCRIPT.size.1.log
test_text $SCRIPT.size.2.log
