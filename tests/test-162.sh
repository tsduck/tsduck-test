#!/usr/bin/env bash
# Plugin pcap and tspcap with VLAN

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tspcap) --list-streams $(fpath "$INDIR/$SCRIPT.pcap") \
    >"$OUTDIR/$SCRIPT.tspcap.1.log" 2>&1

test_text $SCRIPT.tspcap.1.log

$(tspath tspcap) --list-streams --vlan-id 100 $(fpath "$INDIR/$SCRIPT.pcap") \
    >"$OUTDIR/$SCRIPT.tspcap.2.log" 2>&1

test_text $SCRIPT.tspcap.2.log

$(tspath tspcap) --list-streams --vlan-id 123 $(fpath "$INDIR/$SCRIPT.pcap") \
    >"$OUTDIR/$SCRIPT.tspcap.3.log" 2>&1

test_text $SCRIPT.tspcap.3.log

test_tsp \
    -I pcap $(fpath "$INDIR/$SCRIPT.pcap") \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1

test_text $SCRIPT.tsp.1.log
test_bin $SCRIPT.1.ts

touch "$OUTDIR/$SCRIPT.2.ts"
test_tsp \
    -I pcap --vlan-id 100 $(fpath "$INDIR/$SCRIPT.pcap") \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1

test_text $SCRIPT.tsp.2.log
test_bin $SCRIPT.2.ts

test_tsp \
    -I pcap --vlan-id 123 $(fpath "$INDIR/$SCRIPT.pcap") \
    -O file $(fpath "$OUTDIR/$SCRIPT.3.ts") \
    >"$OUTDIR/$SCRIPT.tsp.3.log" 2>&1

test_text $SCRIPT.tsp.3.log
test_bin $SCRIPT.3.ts
