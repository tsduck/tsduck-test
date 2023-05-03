#!/usr/bin/env bash
# Plugin eitinject with options --synchronous-versions and --lazy-schedule-update

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# The input file contains 290 events on service 1. All events last 30 minutes.
# First event starts at 2023:03:01 20:00:00.
INFILE="$INDIR/$SCRIPT.xml"

# Basic signalization for the tests.
PAT="<?xml version='1.0' encoding='UTF-8'?><tsduck><PAT transport_stream_id='1'/></tsduck>"
TDT="<?xml version='1.0' encoding='UTF-8'?><tsduck><TDT UTC_time='2000-01-01 00:00:00'/></tsduck>"
BITRATE=1000000

# Expected number of bytes for a number of hours.
hours-to-bytes() { echo $(( ($1 * 3600 * $BITRATE) / 8)); }

# Test 1: default options, from 20:10 to 22:10.
# EITp/f update every 30 mn.
# Current EITs section update every 30 mn (one section at 20:30, 21:00, 21:30, 22:00).
test_tsp --bitrate $BITRATE \
    -I null \
    -P until --bytes $(hours-to-bytes 2) \
    -P inject -s -b 15,000 -p 0 "$PAT" \
    -P inject -s -b 25 -p 20 "$TDT" \
    -P timeref --start "2023:03:01 20:10:00" \
    -P eitinject --wait-first-batch --file $(fpath "$INFILE") --terrestrial \
    -P tables --all-sections --no-deep-duplicate --log --packet-index \
    -O drop \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.log

# Test 2: --lazy-schedule-update, from 20:10 to 22:10.
# EITp/f update every 30 mn.
# Current EITs section update at segment boundary only (one section at 21:00).
test_tsp --bitrate $BITRATE \
    -I null \
    -P until --bytes $(hours-to-bytes 2) \
    -P inject -s -b 15,000 -p 0 "$PAT" \
    -P inject -s -b 25 -p 20 "$TDT" \
    -P timeref --start "2023:03:01 20:10:00" \
    -P eitinject --wait-first-batch --file $(fpath "$INFILE") --terrestrial --lazy-schedule-update \
    -P tables --all-sections --no-deep-duplicate --log --packet-index \
    -O drop \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.log

# Test 3: --lazy-schedule-update --synchronous-versions, from 20:10 to 22:10.
# EITp/f update every 30 mn.
# Current EITs sub-table update at segment boundary only (all sections at 21:00).
test_tsp --bitrate $BITRATE \
    -I null \
    -P until --bytes $(hours-to-bytes 2) \
    -P inject -s -b 15,000 -p 0 "$PAT" \
    -P inject -s -b 25 -p 20 "$TDT" \
    -P timeref --start "2023:03:01 20:10:00" \
    -P eitinject --wait-first-batch --file $(fpath "$INFILE") --terrestrial --lazy-schedule-update --synchronous-versions \
    -P tables --all-sections --no-deep-duplicate --log --packet-index \
    -O drop \
    >"$OUTDIR/$SCRIPT.3.log" 2>&1

test_text $SCRIPT.3.log
