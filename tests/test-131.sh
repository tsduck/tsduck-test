#!/usr/bin/env bash
# Plugin "rist".

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# There is a bug in RIST on Windows.
[[ $OS == windows ]] && exit 0

# Run the test only if rist is supported on this platform
if $(tspath tsversion) --support rist; then

    BASE_PORT=$(( 20020 + ($$ % 40000) ))
    TSP_PORT=$(( $BASE_PORT ))
    RIST_PORT=$(( $BASE_PORT + 1 ))

    test_tsp -b 1,000,000 --control-port $TSP_PORT \
        -I null \
        -P regulate \
        -P inject --pid 0 --bitrate 15,000 --stuffing $(fpath "$INDIR/$SCRIPT.xml") \
        -O rist "rist://127.0.0.1:$RIST_PORT?aes-type=128&secret=abcdefgh" --null-packet-deletion \
        >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1 &

    outpid=$!

    test_tsp \
        -I rist "rist://@127.0.0.1:$RIST_PORT?aes-type=128&secret=abcdefgh" \
        -P tables --max-tables 1 --pid 0 --xml $(fpath "$OUTDIR/$SCRIPT.2.xml") --binary-output $(fpath "$OUTDIR/$SCRIPT.2.bin") \
        -O drop \
        >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1

    $(tspath tspcontrol) --tsp $TSP_PORT exit
    wait $outpid

    # Remove RIST error messages about performances and response tile.
    sed -i \
        -e '/rist:.*Failed to set .* scheduler/d' \
        -e '/rist:.*RIST receive queue /d' \
        "$OUTDIR/$SCRIPT.tsp.1.log" "$OUTDIR/$SCRIPT.tsp.2.log"

    test_text $SCRIPT.tsp.1.log
    test_bin $SCRIPT.2.bin
    test_text $SCRIPT.2.xml
    test_text $SCRIPT.tsp.2.log

fi
