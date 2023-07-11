#!/usr/bin/env bash
# Plugin "ip".

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

BASE_PORT=$(( 20000 + ($$ % 40000) ))
TSP_PORT=$(( $BASE_PORT ))
UDP_PORT=$(( $BASE_PORT + 1 ))

test_tsp -b 1,000,000 --control-port $TSP_PORT \
    -I null \
    -P inject --pid 0 --bitrate 15,000 $(fpath "$INDIR/$SCRIPT.xml") \
    -O ip 127.0.0.1:$UDP_PORT --enforce-burst --local-address 127.0.0.1 \
    >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1 &

outpid=$!

test_tsp \
    -I ip $UDP_PORT --local-address 127.0.0.1 \
    -P tables --max-tables 1 --pid 0 --xml $(fpath "$OUTDIR/$SCRIPT.xml") --binary-output $(fpath "$OUTDIR/$SCRIPT.bin") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1

$(tspath tspcontrol) --tsp $TSP_PORT exit

wait $outpid

test_bin $SCRIPT.bin
test_text $SCRIPT.xml
test_text $SCRIPT.tsp.1.log
test_text $SCRIPT.tsp.2.log
