#!/usr/bin/env bash
# Load test on ECMG using valgrind.
# Debug binaries must be present in tsduck repo.

source $(dirname "$0")/../../../tsduck/scripts/setenv.sh --debug
source $(dirname "$0")/../../common/testrc.sh
ECMG_PORT=34567
CHANNELS=10
STREAMS=30

# Valgrind command.
VALGRIND="valgrind --quiet --leak-check=full --show-leak-kinds=all"

# Run tsecmg in background.
$VALGRIND $(tspath tsecmg) --port $ECMG_PORT --comp-time 200 --client-limit $CHANNELS \
    >"$TMPDIR/$SCRIPT.tsecmg.log" 2>&1 &
ecmg_pid=$!
sleep 0.5

# Run the load test.
$VALGRIND $(tspath tstestecmg) localhost:$ECMG_PORT --verbose \
    --super-cas-id 0x12345678 --cp-duration 3 \
    --statistics-interval 5 --max-seconds 30 \
    --channels $CHANNELS --streams-per-channel 30 \
    >"$TMPDIR/$SCRIPT.tstestecmg.log" 2>&1

# Wait for tsecmg.
wait $ecmg_pid

echo "Output files:"
ls -l "$TMPDIR/$SCRIPT.tsecmg.log" "$TMPDIR/$SCRIPT.tstestecmg.log"
