#!/usr/bin/env bash
# http output plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

PORT=3258

test_tsp \
    -I craft --pid 100 --count 145 \
    -O http --server $PORT \
    >"$OUTDIR/$SCRIPT.send.log" 2>&1 &

tsp_pid=$!
sleep 0.5

test_tsp \
    -I http http://$LOCALHOST:$PORT/ \
    -O file $(fpath "$OUTDIR/$SCRIPT.ts") 
    >"$OUTDIR/$SCRIPT.receive.log" 2>&1 &

wait $tsp_pid

test_bin $SCRIPT.ts
test_text $SCRIPT.send.log
test_text $SCRIPT.receive.log
