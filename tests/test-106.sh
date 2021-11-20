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
