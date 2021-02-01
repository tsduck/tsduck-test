#!/bin/bash
# tsscan with tuner emulator

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tsscan) --device $(fpath "$INDIR/$SCRIPT.xml") \
    --uhf-band --first-channel 21 --last-channel 28 \
    --service-list --global-service-list --show-modulation \
    --hf-band-region europe \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.log

$(tspath tsscan) --device $(fpath "$INDIR/$SCRIPT.xml") \
    --uhf-band --first-channel 23 --last-channel 23 \
    --service-list --global-service-list --show-modulation \
    --hf-band-region europe --japan \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.log

$(tspath tsscan) --device $(fpath "$INDIR/$SCRIPT.xml") \
    --uhf-band --first-channel 24 --last-channel 24 \
    --service-list --global-service-list --show-modulation \
    --hf-band-region europe --default-pds eacem \
    >"$OUTDIR/$SCRIPT.3.log" 2>&1

test_text $SCRIPT.3.log
