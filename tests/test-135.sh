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

test_tsp \
    -I pcap $(fpath "$INDIR/$SCRIPT.rtsp.pcap") --http --source 10.31.51.78:554 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.rtsp.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.rtsp.ts") \
    >"$OUTDIR/$SCRIPT.rtsp.log" 2>&1

test_bin $SCRIPT.rtsp.ts
test_text $SCRIPT.rtsp.txt
test_text $SCRIPT.rtsp.log

$(tspath tspcap) $(fpath "$INDIR/$SCRIPT.rtsp.pcap") --source 10.31.51.78:554 \
    --output-tcp-stream $(fpath "$OUTDIR/$SCRIPT.rtsp.tcp.bin") \
    >"$OUTDIR/$SCRIPT.rtsp.tcp.log" 2>&1

test_bin $SCRIPT.rtsp.tcp.bin
test_text $SCRIPT.rtsp.tcp.log

test_tsp \
    -I pcap $(fpath "$INDIR/$SCRIPT.seqwrap.pcap") --http --source 10.31.51.78:554 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.seqwrap.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.seqwrap.ts") \
    >"$OUTDIR/$SCRIPT.seqwrap.log" 2>&1

test_bin $SCRIPT.seqwrap.ts
test_text $SCRIPT.seqwrap.txt
test_text $SCRIPT.seqwrap.log
