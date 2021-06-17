#!/bin/bash
# eitinject plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Low TS bitrate and short cycles to reduce file size.
BITRATE=1000000
CYCLES="--prime-days 1
    --cycle-pf-actual 2 --cycle-pf-other 5
    --cycle-schedule-actual-prime 5 --cycle-schedule-other-prime 10
    --cycle-schedule-actual-later 10 --cycle-schedule-other-later 15"

# Looking for GNU date command: "gdate" first, then "date" if not found.
DATE=$(which gdate 2>/dev/null)
DATE=${DATE:-date}

# XML template for a some tables.
TDTXML="<?xml version='1.0' encoding='UTF-8'?><tsduck><TDT UTC_time='2000-01-01 00:00:00'/></tsduck>"
PATXML="<?xml version='1.0' encoding='UTF-8'?><tsduck><PAT transport_stream_id='7'/></tsduck>"

# Add time stamp in tables output file.
addutc() {
    local file=$1
    local start=$($DATE -d "$2" +%s)
    local bitrate=$3
    local line pkt utc
    dos2unix -q "$file"
    while IFS= read -r line; do
        if [[ $line == *First\ TS\ packet:* ]]; then
            line=${line/, last:*/}
            pkt=${line/*First TS packet: /}
            pkt=${pkt//,/}
            utc=$($DATE -d @$(( $start + (($pkt * 188 * 8) / $bitrate) )) '+%Y-%m-%d %H:%M:%S')
            line=$(printf "%s, UTC: %s.%02d" "$line" "$utc" $(( (($pkt * 188 * 8 * 100) / $bitrate) % 100 )) )
        fi
        echo "$line"
    done <"$file" >"$file.new"
    mv "$file.new" "$file"
}

# Create TS at 1 Mb/s, total duration: 32 seconds, TDT insertion every 10 seconds.

$(tspath tsp) --synchronous-log --bitrate $BITRATE \
    -I null \
    -P until --bytes 4,000,000 \
    -P inject "$PATXML" --pid 0 --bitrate 3000 --stuffing \
    -P inject "$TDTXML" --pid 20 --bitrate 150 --stuffing \
    -P timeref --start 2020/07/01:08:57:00 \
    -P eitinject --file $(fpath "$INDIR/$SCRIPT.xml") --wait-first-batch --stuffing $CYCLES \
    -P tables -a -p 18-20 -o $(fpath "$OUTDIR/$SCRIPT.1.txt") --packet-index \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

addutc "$OUTDIR/$SCRIPT.1.txt" "2020/07/01 08:57:00" $BITRATE >"$OUTDIR/$SCRIPT.1.addutc.log" 2>&1

test_text $SCRIPT.1.txt
test_text $SCRIPT.1.log
test_text $SCRIPT.1.addutc.log
test_bin $SCRIPT.1.ts

# Test the midnight effect.

$(tspath tsp) --synchronous-log --bitrate $BITRATE \
    -I null \
    -P until --bytes 4,000,000 \
    -P inject "$PATXML" --pid 0 --bitrate 3000 --stuffing \
    -P inject "$TDTXML" --pid 20 --bitrate 150 --stuffing \
    -P timeref --start 2020/07/01:23:59:50 \
    -P eitinject --file $(fpath "$INDIR/$SCRIPT.xml") --wait-first-batch --stuffing $CYCLES \
    -P tables -a -p 18-20 -o $(fpath "$OUTDIR/$SCRIPT.2.txt") --packet-index \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

addutc "$OUTDIR/$SCRIPT.2.txt" "2020/07/01 23:59:50" $BITRATE >"$OUTDIR/$SCRIPT.2.addutc.log" 2>&1

test_text $SCRIPT.2.txt
test_text $SCRIPT.2.log
test_text $SCRIPT.2.addutc.log
test_bin $SCRIPT.2.ts
