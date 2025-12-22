#!/usr/bin/env bash
# tsp and tspcontrol with TLS control port

source $(dirname $0)/../common/testrc.sh
source "$COMMONDIR/setup-tls-certificate.sh"
test_cleanup "$SCRIPT.*"

PORT=7425

test_tsp --bitrate 1,000,000 --control $LOCALHOST:$PORT --control-reuse-port \
    -I null \
    -P regulate \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1 &

tsp_pid=$!
sleep 0.5

$(tspath tspcontrol) --tsp $LOCALHOST:$PORT list \
    >"$OUTDIR/$SCRIPT.tspcontrol.1a.log" 2>&1

$(tspath tspcontrol) --tsp $LOCALHOST:$PORT exit \
    >"$OUTDIR/$SCRIPT.tspcontrol.1b.log" 2>&1

wait $tsp_pid

test_text $SCRIPT.tsp.1.log
test_text $SCRIPT.tspcontrol.1a.log
test_text $SCRIPT.tspcontrol.1b.log

test_tsp --bitrate 1,000,000 --control $LOCALHOST:$PORT --control-reuse-port --control-tls --control-token Test-Token \
    -I null \
    -P regulate \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1 &

tsp_pid=$!
sleep 0.5

$(tspath tspcontrol) --tsp $LOCALHOST:$PORT --tls --insecure --token Test-Token list \
    >"$OUTDIR/$SCRIPT.tspcontrol.2a.log" 2>&1

$(tspath tspcontrol) --tsp $LOCALHOST:$PORT --tls --insecure --token Wrong-Token list \
    >"$OUTDIR/$SCRIPT.tspcontrol.2b.log" 2>&1

$(tspath tspcontrol) --tsp $LOCALHOST:$PORT --tls --insecure --token Test-Token exit \
    >"$OUTDIR/$SCRIPT.tspcontrol.2c.log" 2>&1

wait $tsp_pid

sed -i -e 's|127.0.0.1:[0-9]*|xxxx|' "$OUTDIR/$SCRIPT.tsp.2.log"

test_text $SCRIPT.tsp.2.log
test_text $SCRIPT.tspcontrol.2a.log
test_text $SCRIPT.tspcontrol.2b.log
test_text $SCRIPT.tspcontrol.2c.log
