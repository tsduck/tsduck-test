#!/usr/bin/env bash
# Plugin "ip".

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

BASE_PORT=$(( 20000 + ($$ % 40000) ))
TSP_PORT=$(( $BASE_PORT ))
UDP_PORT_1=$(( $BASE_PORT + 1 ))
UDP_PORT_2=$(( $BASE_PORT + 2 ))

test_tsp -b 1,000,000 --control-port $TSP_PORT \
    -I null \
    -P regulate \
    -P inject --pid 0 --bitrate 15,000 --stuffing $(fpath "$INDIR/$SCRIPT.xml") \
    -P ip $LOCALHOST:$UDP_PORT_1 --local-address $LOCALHOST \
    -O ip $LOCALHOST:$UDP_PORT_2 --enforce-burst --local-address $LOCALHOST \
    >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1 &

outpid=$!

test_tsp \
    -I ip $UDP_PORT_1 --local-address $LOCALHOST \
    -P tables --max-tables 1 --pid 0 --xml $(fpath "$OUTDIR/$SCRIPT.2.xml") --binary-output $(fpath "$OUTDIR/$SCRIPT.2.bin") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1

test_tsp \
    -I ip $UDP_PORT_2 --local-address $LOCALHOST \
    -P tables --max-tables 1 --pid 0 --xml $(fpath "$OUTDIR/$SCRIPT.3.xml") --binary-output $(fpath "$OUTDIR/$SCRIPT.3.bin") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.3.log" 2>&1

$(tspath tspcontrol) --tsp $TSP_PORT exit
wait $outpid

test_text $SCRIPT.tsp.1.log

test_bin $SCRIPT.2.bin
test_text $SCRIPT.2.xml
test_text $SCRIPT.tsp.2.log

test_bin $SCRIPT.3.bin
test_text $SCRIPT.3.xml
test_text $SCRIPT.tsp.3.log
