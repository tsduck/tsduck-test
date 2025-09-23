#!/usr/bin/env bash
# Non-regression on plugin pat when the TS id changes (issue #1668)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Simulate a PAT change after a while.
# Set label 1 on first 100 packets, label 2 afterwards.
# PAT1 is insert every 10 packaet in first 100 packets. PAT2 is inserted afterwards.

PAT1="<?xml?><tsduck><PAT transport_stream_id='1'><service service_id='1' program_map_PID='100'/></PAT></tsduck>"
PAT2="<?xml?><tsduck><PAT transport_stream_id='2'><service service_id='2' program_map_PID='200'/></PAT></tsduck>"

test_tsp \
    -I null \
    -P filter --negate --set-label 1 \
    -P filter --negate --after-packets 100 --reset-label 1 --set-label 2 \
    -P inject --only-label 1 "$PAT1" --pid 0 --inter-packet 10 --stuffing \
    -P inject --only-label 2 "$PAT2" --pid 0 --inter-packet 10 --stuffing \
    -P continuity --fix --pid 0 \
    -P pat --inter-packet 10 --add-service 3/300 \
    -P until --packets 200 \
    -P tables --all-sections --packet-index \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_text $SCRIPT.tsp.log
