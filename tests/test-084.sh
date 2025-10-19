#!/usr/bin/env bash
# Options --patch-xml

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P splicemonitor --packet-index \
    -O drop \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.log

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P splicemonitor --packet-index --display-commands -o $(fpath "$OUTDIR/$SCRIPT.2.txt") \
    -P splicemonitor --all-commands --splice-pid 1055 -o $(fpath "$OUTDIR/$SCRIPT.3.txt") \
    -P splicemonitor --all-commands --json -o $(fpath "$OUTDIR/$SCRIPT.4.json") \
    -P splicemonitor --json -o $(fpath "$OUTDIR/$SCRIPT.5.json") \
    -P splicemonitor --all-commands --json --meta-sections -o $(fpath "$OUTDIR/$SCRIPT.6.json") \
    -O drop \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.log
test_text $SCRIPT.2.txt
test_text $SCRIPT.3.txt
test_text $SCRIPT.4.json
test_text $SCRIPT.5.json

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P splicemonitor --json-line=FOO: \
    -O drop \
    >"$OUTDIR/$SCRIPT.6.log" 2>&1

test_text $SCRIPT.6.log

# Test with InfluxDB options.
INFLUX_PORT=47878

$(tspath tsdebug) server :$INFLUX_PORT --max-clients 8 \
    --sort-headers --hide-header Connection --hide-header Cache-Control \
    >"$OUTDIR/$SCRIPT.7.log" 2>&1 &

server_pid=$!
sleep 0.5

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P splicemonitor --influx all --influx-pcr-based --influx-start-time 2025/07/14:12:34:56 \
                     --influx-host-url http://$LOCALHOST:$INFLUX_PORT/ --influx-bucket test-bucket \
                     --influx-org test-org --influx-token test-token \
    -O drop \
    >"$OUTDIR/$SCRIPT.8.log" 2>&1

wait $server_pid

test_text $SCRIPT.7.log
test_text $SCRIPT.8.log
