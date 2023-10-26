#!/usr/bin/env bash
# Test pcap plugin option --http

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I pcap $(fpath "$INDIR/$SCRIPT.full.pcapng") --http --source 192.168.56.101:80 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.full.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.full.ts") \
    >"$OUTDIR/$SCRIPT.full.log" 2>&1

test_bin $SCRIPT.full.ts
test_text $SCRIPT.full.txt
test_text $SCRIPT.full.log

test_tsp \
    -I pcap $(fpath "$INDIR/$SCRIPT.partial.pcapng") --http --source 192.168.56.101:80 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.partial.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.partial.ts") \
    >"$OUTDIR/$SCRIPT.partial.log" 2>&1

test_bin $SCRIPT.partial.ts
test_text $SCRIPT.partial.txt
test_text $SCRIPT.partial.log
