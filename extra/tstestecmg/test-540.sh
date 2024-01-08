#!/usr/bin/env bash
# Load test on ECMG.

source $(dirname "$0")/../../common/testrc.sh
ECMG_PORT=34567

# Run tsecmg in background.
$(tspath tsecmg) --port $ECMG_PORT --comp-time 100 &
ecmg_pid=$!
sleep 0.5

# Run the load test.
$(tspath tstestecmg) localhost:$ECMG_PORT --verbose \
    --super-cas-id 0x12345678 --cp-duration 3 \
    --statistics-interval 5 --max-seconds 30 \
    --channels 20 --streams-per-channel 20

# Kill the background ECMG.
kill -KILL $ecmg_pid
