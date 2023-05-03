#!/usr/bin/env bash
# Pcap file with EMMG <=> MUX DVB SimulCrypt protocol

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tspcap) $(fpath "$INDIR/$SCRIPT.1.pcapng") --list-streams \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

$(tspath tspcap) $(fpath "$INDIR/$SCRIPT.2.pcapng") --list-streams \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.1.log
test_text $SCRIPT.2.log

$(tspath tspcap) $(fpath "$INDIR/$SCRIPT.2.pcapng") --dvb-simulcrypt --udp \
    >"$OUTDIR/$SCRIPT.3.log" 2>&1

test_text $SCRIPT.3.log

$(tspath tspcap) $(fpath "$INDIR/$SCRIPT.1.pcapng") --dvb-simulcrypt \
    >"$OUTDIR/$SCRIPT.4.log" 2>&1

test_text $SCRIPT.4.log

test_tsp \
    -I pcap --udp-emmg-mux $(fpath "$INDIR/$SCRIPT.2.pcapng") \
    -O file $(fpath "$OUTDIR/$SCRIPT.5.ts") \
    >"$OUTDIR/$SCRIPT.5.log" 2>&1

test_bin $SCRIPT.5.ts
test_text $SCRIPT.5.log

test_tsp \
    -I pcap --tcp-emmg-mux $(fpath "$INDIR/$SCRIPT.1.pcapng") \
    -O file $(fpath "$OUTDIR/$SCRIPT.6.ts") \
    >"$OUTDIR/$SCRIPT.6.log" 2>&1

test_bin $SCRIPT.6.ts
test_text $SCRIPT.6.log
