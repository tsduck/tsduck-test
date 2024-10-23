#!/usr/bin/env bash
# Options --event-offset and --input-event-offset in plugin eitinject

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Input:
# - XML file 1 generates the initial EIT PID.
# - XML file 2 injects EIT in addition to the input PID. We apply the event offsets here.
# Output:
# - We only extract the first 6 sections from the EIT PID.
# - 2 EIT p/f for service 1.
# - 2 EIT p/f for service 2.
# - 1 ETI schedule for service 1.
# - 1 ETI schedule for service 2.
# Control:
# - Low TS bitrate and short cycles to reduce processing time.
# - Generate PAT and TDT on the fly.

BITRATE=1000000
CYCLES="--cycle-pf-actual 1 --cycle-schedule-actual-prime 1"
TDTXML="<?xml version='1.0' encoding='UTF-8'?><tsduck><TDT UTC_time='2000-01-01 00:00:00'/></tsduck>"
PATXML="<?xml version='1.0' encoding='UTF-8'?><tsduck><PAT transport_stream_id='1'/></tsduck>"

# One test, syntax: onetest test-index eitinject-options
onetest() {
    local index=$1
    local opts="$2"

    test_tsp --bitrate $BITRATE \
        -I null \
        -P inject "$PATXML" --pid 0 --bitrate 3000 --stuffing \
        -P inject "$TDTXML" --pid 20 --bitrate 150 --stuffing \
        -P timeref --start 2020/07/01:01:00:00 \
        -P eitinject --file $(fpath "$INDIR/$SCRIPT.1.xml") --wait-first-batch --stuffing $CYCLES \
        -P eitinject --file $(fpath "$INDIR/$SCRIPT.2.xml") --wait-first-batch --stuffing $CYCLES --incoming-eits $opts \
        -P tables --all-once --pid 18 --max-tables 6 --text $(fpath "$OUTDIR/$SCRIPT.$index.txt") \
        -O drop \
        >"$OUTDIR/$SCRIPT.$index.log" 2>&1

    test_text $SCRIPT.$index.txt
    test_text $SCRIPT.$index.log
}

onetest 1
onetest 2 "--event-offset +15"
onetest 3 "--event-offset +10 --input-event-offset -10"
