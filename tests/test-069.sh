#!/usr/bin/env bash
# Non-regression on tsecmg (issue #619)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# ECMG listens on this port number.
PORT=31456

# Crypto-periods numbers 0 and 1.
$(tspath tsecmg) \
    --once --port $PORT \
    >"$OUTDIR/$SCRIPT.tsecmg.1.log" 2>&1 &

ecmg_pid=$!
sleep 0.5

$(tspath tsgenecm) $(fpath "$OUTDIR/$SCRIPT.ecm.1.bin") \
    --ecmg $LOCALHOST:$PORT --super-cas-id 0x12345678 \
    --log-protocol=info --log-data=info \
    --cw-current 0123456789ABCDEF --cw-next FEDCBA9876543210 \
    --access-criteria 1478523690 \
    --cp-number 0x0000 \
    >"$OUTDIR/$SCRIPT.tsgenecm.1.log" 2>&1

wait $ecmg_pid

test_text $SCRIPT.tsecmg.1.log
test_text $SCRIPT.tsgenecm.1.log
test_bin $SCRIPT.ecm.1.bin

# Crypto-periods numbers 0x7FFF and 0x8000.
$(tspath tsecmg) \
    --once --port $PORT \
    >"$OUTDIR/$SCRIPT.tsecmg.2.log" 2>&1 &

ecmg_pid=$!
sleep 0.5

$(tspath tsgenecm) $(fpath "$OUTDIR/$SCRIPT.ecm.2.bin") \
    --ecmg $LOCALHOST:$PORT --super-cas-id 0x12345678 \
    --log-protocol=info --log-data=info \
    --cw-current 0123456789ABCDEF --cw-next FEDCBA9876543210 \
    --access-criteria 1478523690 \
    --cp-number 0x7FFF \
    >"$OUTDIR/$SCRIPT.tsgenecm.2.log" 2>&1

wait $ecmg_pid

test_text $SCRIPT.tsecmg.2.log
test_text $SCRIPT.tsgenecm.2.log
test_bin $SCRIPT.ecm.2.bin

# Crypto-periods numbers 0xFFFF and 0x0000.
$(tspath tsecmg) \
    --once --port $PORT \
    >"$OUTDIR/$SCRIPT.tsecmg.3.log" 2>&1 &

ecmg_pid=$!
sleep 0.5

$(tspath tsgenecm) $(fpath "$OUTDIR/$SCRIPT.ecm.3.bin") \
    --ecmg $LOCALHOST:$PORT --super-cas-id 0x12345678 \
    --log-protocol=info --log-data=info \
    --cw-current 0123456789ABCDEF --cw-next FEDCBA9876543210 \
    --access-criteria 1478523690 \
    --cp-number 0xFFFF \
    >"$OUTDIR/$SCRIPT.tsgenecm.3.log" 2>&1

wait $ecmg_pid

test_text $SCRIPT.tsecmg.3.log
test_text $SCRIPT.tsgenecm.3.log
test_bin $SCRIPT.ecm.3.bin
