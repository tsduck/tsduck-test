#!/bin/bash
# Pcap file with EMMG <=> MUX DVB SimulCrypt protocol

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tspcap) $(fpath "$INDIR/$SCRIPT.1.pcapng") --list-streams \
    >"$OUTDIR/$SCRIPT.list.1.log" 2>&1

$(tspath tspcap) $(fpath "$INDIR/$SCRIPT.2.pcapng") --list-streams \
    >"$OUTDIR/$SCRIPT.list.2.log" 2>&1

test_text $SCRIPT.list.1.log
test_text $SCRIPT.list.2.log

$(tspath tspcap) $(fpath "$INDIR/$SCRIPT.2.pcapng") --dvb-simulcrypt --udp \
    >"$OUTDIR/$SCRIPT.list.3.log" 2>&1

test_text $SCRIPT.list.3.log

$(tspath tspcap) $(fpath "$INDIR/$SCRIPT.1.pcapng") --dvb-simulcrypt \
    >"$OUTDIR/$SCRIPT.list.4.log" 2>&1

test_text $SCRIPT.list.4.log
