#!/usr/bin/env bash
# Plugin tables with --ip-udp.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

PID=20
CONTROL1=9201
CONTROL2=9202
CONTROL3=9203
OUTPORT1=9204
OUTPORT2=9205
OUTPORT3=9206

# Send binary tables.

test_tsp --bitrate 100,000 --control-port $CONTROL1 --control-source $LOCALHOST \
    -I null \
    -P regulate \
    -P inject $(fpath "$INDIR/$SCRIPT.xml") --pid $PID --stuffing --bitrate 10,000 \
    -P tables --pid $PID --ip-udp $LOCALHOST:$OUTPORT1 --no-encapsulation \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1 &

tspid=$!

$(tspath tsdump) \
    --ip-udp $OUTPORT1 --local-address $LOCALHOST --no-pager --ascii --no-header --max-packets 1 \
    >"$OUTDIR/$SCRIPT.tsdump.1.log" 2>&1 &

sleep 0.5

$(tspath tspcontrol) --tsp $CONTROL1 exit \
    >"$OUTDIR/$SCRIPT.exit.1.log" 2>&1

wait $tspid

test_text $SCRIPT.tsp.1.log
test_text $SCRIPT.tsdump.1.log
test_text $SCRIPT.exit.1.log

# Send XML tables.

test_tsp --bitrate 100,000 --control-port $CONTROL2 --control-source $LOCALHOST \
    -I null \
    -P regulate \
    -P inject $(fpath "$INDIR/$SCRIPT.xml") --pid $PID --stuffing --bitrate 10,000 \
    -P tables --pid $PID --ip-udp $LOCALHOST:$OUTPORT2 --udp-format xml \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1 &

tspid=$!

$(tspath tsdump) \
    --ip-udp $OUTPORT2 --local-address $LOCALHOST --no-pager --ascii --no-header --max-packets 1 \
    >"$OUTDIR/$SCRIPT.tsdump.2.log" 2>&1 &

sleep 0.5

$(tspath tspcontrol) --tsp $CONTROL2 exit \
    >"$OUTDIR/$SCRIPT.exit.2.log" 2>&1

wait $tspid

test_text $SCRIPT.tsp.2.log
test_text $SCRIPT.tsdump.2.log
test_text $SCRIPT.exit.2.log

# Send JSON tables.

test_tsp --bitrate 100,000 --control-port $CONTROL3 --control-source $LOCALHOST \
    -I null \
    -P regulate \
    -P inject $(fpath "$INDIR/$SCRIPT.xml") --pid $PID --stuffing --bitrate 10,000 \
    -P tables --pid $PID --ip-udp $LOCALHOST:$OUTPORT3 --udp-format json \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.3.log" 2>&1 &

tspid=$!

$(tspath tsdump) \
    --ip-udp $OUTPORT3 --local-address $LOCALHOST --no-pager --ascii --no-header --max-packets 1 \
    >"$OUTDIR/$SCRIPT.tsdump.3.log" 2>&1 &

sleep 0.5

$(tspath tspcontrol) --tsp $CONTROL3 exit \
    >"$OUTDIR/$SCRIPT.exit.3.log" 2>&1

wait $tspid

test_text $SCRIPT.tsp.3.log
test_text $SCRIPT.tsdump.3.log
test_text $SCRIPT.exit.3.log
