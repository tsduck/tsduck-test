#!/usr/bin/env bash
# Plugin influx

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"
INFLUX_PORT=47852

$(tspath tsdebug) server :$INFLUX_PORT --max-clients 3 \
    --sort-headers --hide-header Connection --hide-header Cache-Control \
    >"$OUTDIR/$SCRIPT.server.log" 2>&1 &

server_pid=$!
sleep 0.5

test_tsp \
    -I file --infinite $(fpath "$INFILE") \
    -P influx --interval 3 --max-metrics 3 --pcr-based --start-time 2025/07/14:12:34:56 \
              --all-pids --services --names --type \
              --host-url http://localhost:$INFLUX_PORT/ --bucket test-bucket --org test-org --token test-token \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

wait $server_pid

test_text $SCRIPT.server.log
test_text $SCRIPT.tsp.log
