#!/usr/bin/env bash
# Plugin eitinject: preservation of midnight events in EIT p/f (issue #1724)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

TDTXML="<?xml version='1.0' encoding='UTF-8'?><tsduck><TDT UTC_time='2000-01-01 00:00:00'/></tsduck>"
PATXML="<?xml version='1.0' encoding='UTF-8'?><tsduck><PAT transport_stream_id='1'/></tsduck>"

test_tsp --bitrate 1,000,000 \
    -I null \
    -P inject "$PATXML" --pid 0 --bitrate 3000 --stuffing \
    -P inject "$TDTXML" --pid 20 --bitrate 1500 --stuffing \
    -P timeref --start 2026/05/28:23:59:55 \
    -P eitinject --file  $(fpath "$INDIR/$SCRIPT.xml") --wait-first-batch \
                 --stuffing --cycle-pf-actual 2 --cycle-schedule-actual-prime 2 \
    -P until --packet 7000 \
    -P tables --packet-index --all-sections --pid 18-20 -o $(fpath "$OUTDIR/$SCRIPT.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.log
test_text $SCRIPT.txt
