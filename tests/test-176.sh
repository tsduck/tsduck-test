#!/usr/bin/env bash
# Plugin pcap and tspcap with IPv6 capture

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/$SCRIPT.pcapng"

$(tspath tspcap) $(fpath "$INFILE") \
    >"$OUTDIR/$SCRIPT.tspcap.1.log" 2>&1

test_text $SCRIPT.tspcap.1.log

$(tspath tspcap) --list-streams $(fpath "$INFILE") \
    >"$OUTDIR/$SCRIPT.tspcap.2.log" 2>&1

test_text $SCRIPT.tspcap.2.log

test_tsp \
    -I pcap $(fpath "$INFILE") --destination 192.168.233.11:7777 \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1

test_text $SCRIPT.tsp.1.log
test_bin $SCRIPT.1.ts

touch "$OUTDIR/$SCRIPT.2.ts"
test_tsp \
    -I pcap $(fpath "$INFILE") --destination '[fdb2:2c26:f4e4:1:21c:42ff:fe38:46a8]:8888' \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1

test_text $SCRIPT.tsp.2.log
test_bin $SCRIPT.2.ts
