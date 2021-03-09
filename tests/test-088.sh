#!/bin/bash
# Test pcap plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tsp) --synchronous-log \
    -I pcap $(fpath "$INDIR/$SCRIPT.pcapng") \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.pcapng.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.pcapng.ts") \
    >"$OUTDIR/$SCRIPT.pcapng.log" 2>&1

test_bin $SCRIPT.pcapng.ts
test_text $SCRIPT.pcapng.txt
test_text $SCRIPT.pcapng.log

$(tspath tsp) --synchronous-log \
    -I pcap $(fpath "$INDIR/$SCRIPT.pcap") \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.pcap.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.pcap.ts") \
    >"$OUTDIR/$SCRIPT.pcap.log" 2>&1

test_bin $SCRIPT.pcap.ts
test_text $SCRIPT.pcap.txt
test_text $SCRIPT.pcap.log

$(tspath tsp) --synchronous-log \
    -I pcap $(fpath "$INDIR/$SCRIPT.ns.pcap") \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.pcap.ns.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.pcap.ns.ts") \
    >"$OUTDIR/$SCRIPT.pcap.ns.log" 2>&1

test_bin $SCRIPT.pcap.ns.ts
test_text $SCRIPT.pcap.ns.txt
test_text $SCRIPT.pcap.ns.log
