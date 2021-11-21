#!/bin/bash
# tsemmg and datainject plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# MUX listens on this port number.
PORT=31567

# Start MUX session 1.
$(tspath tsp) --synchronous-log --bitrate 1,000,000 \
    -I null \
    -P regulate \
    -P datainject --pid 100 --server $PORT \
    -P filter --pattern DEADBEEF --set-permanent-label 0 \
    -P until --only-label 0 --packets 300 \
    -P filter --pid 100 \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1 &

tsp_pid=$!
sleep 0.5

# Inject EMM's, one cycle, packet mode (default).
$(tspath tsemmg) $(fpath "$INDIR/$SCRIPT.xml") \
    --mux 127.0.0.1:$PORT --log-protocol --cycles 1 --bytes-per-send 188 \
    >"$OUTDIR/$SCRIPT.tsemmg.1.log" 2>&1

wait $tsp_pid

test_bin $SCRIPT.1.ts
test_text $SCRIPT.tsp.1.log
test_text $SCRIPT.tsemmg.1.log

# Start MUX session 2.
$(tspath tsp) --synchronous-log --bitrate 1,000,000 \
    -I null \
    -P regulate \
    -P datainject --pid 100 --server $PORT \
    -P filter --pattern DEADBEEF --set-permanent-label 0 \
    -P until --only-label 0 --packets 300 \
    -P filter --pid 100 \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1 &

tsp_pid=$!
sleep 0.5

# Inject EMM's, one cycle, section mode.
$(tspath tsemmg) $(fpath "$INDIR/$SCRIPT.xml") \
    --mux 127.0.0.1:$PORT --log-protocol --cycles 1 --bytes-per-send 1000 --section-mode \
    >"$OUTDIR/$SCRIPT.tsemmg.2.log" 2>&1

wait $tsp_pid

test_bin $SCRIPT.2.ts
test_text $SCRIPT.tsp.2.log
test_text $SCRIPT.tsemmg.2.log

# Start MUX session 3.
$(tspath tsp) --synchronous-log --bitrate 1,000,000 \
    -I null \
    -P regulate \
    -P datainject --pid 100 --server $PORT \
    -P filter --pattern DEADBEEF --set-permanent-label 0 \
    -P until --only-label 0 --packets 300 \
    -P filter --pid 100 \
    -O file $(fpath "$OUTDIR/$SCRIPT.3.ts") \
    >"$OUTDIR/$SCRIPT.tsp.3.log" 2>&1 &

tsp_pid=$!
sleep 0.5

# Inject EMM's, one cycle, packet mode, UDP transport.
$(tspath tsemmg) $(fpath "$INDIR/$SCRIPT.xml") \
    --mux 127.0.0.1:$PORT --udp 127.0.0.1:$PORT --log-protocol --cycles 1 --bytes-per-send 188 \
    >"$OUTDIR/$SCRIPT.tsemmg.3.log" 2>&1

wait $tsp_pid

test_bin $SCRIPT.3.ts
test_text $SCRIPT.tsp.3.log
test_text $SCRIPT.tsemmg.3.log
