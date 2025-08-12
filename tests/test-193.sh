#!/usr/bin/env bash
# Plugin influx

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"
INFLUX_PORT=47852

influx_test()
{
    local name=$1

    $(tspath tsdebug) server :$INFLUX_PORT --max-clients 3 \
        --sort-headers --hide-header Connection --hide-header Cache-Control \
        >"$OUTDIR/$SCRIPT.server.$name.log" 2>&1 &

    server_pid=$!
    sleep 0.5

    test_tsp \
        -I file --infinite $(fpath "$INFILE") \
        -P influx $2 --interval 3 --max-metrics 3 --pcr-based --start-time 2025/07/14:12:34:56 \
                  --host-url http://localhost:$INFLUX_PORT/ --bucket test-bucket --org test-org --token test-token \
        -O drop \
        >"$OUTDIR/$SCRIPT.tsp.$name.log" 2>&1

    wait $server_pid

    test_text $SCRIPT.server.$name.log
    test_text $SCRIPT.tsp.$name.log
}

influx_test bitrate  "--all-pids --services --names --type"
influx_test pcr      "--pid 200-250 --services --names --pcr --pts --dts"
influx_test ts101290 "--tr-101-290"
