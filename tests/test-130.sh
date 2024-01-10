#!/usr/bin/env bash
# Plugin "srt".

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# disabled on asan build due to openssl 1.1 well-known memleak
# this test should be enabled when CI ubuntu-latest becomes 24.04
exclude_on_asan

# Run the test only if srt is supported on this platform
if $(tspath tsversion) --support srt; then

    PORT=$(( 20010 + ($$ % 40000) ))
    SRTOPT="--transtype live --enforce-encryption --pbkeylen 16 --passphrase abcdefghijklmnop"

    test_tsp -b 1,000,000 \
        -I null \
        -P regulate \
        -P inject --pid 0 --bitrate 15,000 --stuffing $(fpath "$INDIR/$SCRIPT.xml") \
        -O srt --listener 127.0.0.1:$PORT $SRTOPT \
        >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1 &

    outpid=$!

    test_tsp \
        -I srt --caller 127.0.0.1:$PORT --local-interface 127.0.0.1 $SRTOPT \
        -P tables --max-tables 1 --pid 0 --xml $(fpath "$OUTDIR/$SCRIPT.2.xml") --binary-output $(fpath "$OUTDIR/$SCRIPT.2.bin") \
        -O drop \
        >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1

    wait $outpid

    # Remove SRT logs, they are not deterministic.
    sed -i -e '/\/SRT:/d' "$OUTDIR/$SCRIPT.tsp.1.log" "$OUTDIR/$SCRIPT.tsp.2.log"

    test_text $SCRIPT.tsp.1.log
    test_bin $SCRIPT.2.bin
    test_text $SCRIPT.2.xml
    test_text $SCRIPT.tsp.2.log

fi
