#!/usr/bin/env bash
# Non-regression on event duplication in plugin eitinject

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

TDTXML="<?xml version='1.0' encoding='UTF-8'?><tsduck><TDT UTC_time='2000-01-01 00:00:00'/></tsduck>"
PATXML="<?xml version='1.0' encoding='UTF-8'?><tsduck><PAT transport_stream_id='7'/></tsduck>"

test_tsp --bitrate 1000000 \
    -I null \
    -P inject "$PATXML" --pid 0 --bitrate 3000 --stuffing \
    -P inject "$TDTXML" --pid 20 --bitrate 150 --stuffing \
    -P timeref --start 2020/07/01:08:00:00 \
    -P eitinject --file $(fpath "$INDIR/$SCRIPT").\*.xml --wait-first-batch --stuffing \
    -P tables --all-sections --pid 0x12 --tid 0x50 --max-tables 5 -o $(fpath "$OUTDIR/$SCRIPT.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.log
test_text $SCRIPT.txt
