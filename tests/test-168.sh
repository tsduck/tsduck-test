#!/usr/bin/env bash
# Event deletion  in plugin eitinject

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Low TS bitrate (66.5 pkt/sec) and short cycles (1 sec for each EIT) to reduce processing time.
BITRATE=100000
CYCLES="--cycle-pf-actual 1 --cycle-schedule-actual-prime 1"

# Generate PAT and TDT on the fly.
TDTXML="<?xml version='1.0' encoding='UTF-8'?><tsduck><TDT UTC_time='2000-01-01 00:00:00'/></tsduck>"
PATXML="<?xml version='1.0' encoding='UTF-8'?><tsduck><PAT transport_stream_id='1'/></tsduck>"

# Event files are read from $TMPDIR. We copy them here when ready.
cp "$INDIR/$SCRIPT.inject.xml" "$TMPDIR/" >"$OUTDIR/$SCRIPT.cp.log" 2>&1
test_text $SCRIPT.cp.log

# All events are on same service in 0-3 AM range => we expect cycles of 3 EIT: 2 p/f, 1 schedule.
# At a bitrate of 66.5 pkt/s, the first cycle is within the 60 first packets.
# Scenario:
# - Inject first XML file => 3 EIT over 3 TS packets.
# - Set label 2 on all packets of EIT PID after the first cycle (after the first 60 packets).
# - On first packet with label 2 (end of first cycle), copy the second XML file which deletes an event.
# - In the dump of the EIT PID, we find the first cycle with all events, then updated EIT's with the deleted event.
# - Expect 2 additional sections: updated EITs and updated EITpf[1].

test_tsp --bitrate $BITRATE \
    -I null \
    -P regulate \
    -P inject "$PATXML" --pid 0 --bitrate 3000 --stuffing \
    -P inject "$TDTXML" --pid 20 --bitrate 150 --stuffing \
    -P timeref --start 2020/07/01:00:15:00 \
    -P eitinject --file $(fpath "$TMPDIR/")/"$SCRIPT.*.xml" --wait-first-batch --stuffing $CYCLES \
    -P filter --after-packets 60 --pid 18 --set-label 2 \
    -P trigger --once --label 2 --copy $(fpath "$INDIR/$SCRIPT.delete.xml") --destination $(fpath "$TMPDIR") \
    -P tables -p 18 -a --no-deep-duplicate -x 5 -m -b $(fpath "$OUTDIR/$SCRIPT.bin") \
    -O drop \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.log
test_bin ${SCRIPT}_p0012_t4E_e0001_v00_s00.bin
test_bin ${SCRIPT}_p0012_t4E_e0001_v00_s01.bin
test_bin ${SCRIPT}_p0012_t50_e0001_v00_s00.bin
test_bin ${SCRIPT}_p0012_t4E_e0001_v01_s01.bin
test_bin ${SCRIPT}_p0012_t50_e0001_v01_s00.bin

for t in t4E_e0001_v00_s00 t4E_e0001_v00_s01 t50_e0001_v00_s00 t4E_e0001_v01_s01 t50_e0001_v01_s00; do
    $(tspath tstabdump) $(fpath "$OUTDIR/${SCRIPT}_p0012_$t.bin") >"$OUTDIR/${SCRIPT}_p0012_$t.log" 2>&1
    test_text ${SCRIPT}_p0012_$t.log
done
