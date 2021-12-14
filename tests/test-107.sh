#!/bin/bash
# Pcap file with ECMG <=> SCS DVB SimulCrypt protocol

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tspcap) $(fpath "$INDIR/$SCRIPT.pcapng") --list-streams \
    >"$OUTDIR/$SCRIPT.list.log" 2>&1

test_text $SCRIPT.list.log

$(tspath tspcap) $(fpath "$INDIR/$SCRIPT.pcapng") --dvb-simulcrypt --destination 192.168.56.1:2222 \
    >"$OUTDIR/$SCRIPT.dvbsim.log" 2>&1

test_text $SCRIPT.dvbsim.log

$(tspath tspcap) $(fpath "$INDIR/$SCRIPT.pcapng") --extract-tcp-stream --destination 192.168.56.1:2222 \
    >"$OUTDIR/$SCRIPT.hexa.log" 2>&1

test_text $SCRIPT.hexa.log
