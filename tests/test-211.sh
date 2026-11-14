#!/usr/bin/env bash
# Command tsanalyze: identification of DVB-TTML subtitle PID's (ETSI EN 303 560).
# The input is the IRT TTML test stream, without its video, audio and stuffing.
# DVB publishes it under the Creative Commons Attribution 4.0 license:
# https://dvb.org/specifications/verification-validation/dvb-ttml-subtitling-test-streams/

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tsanalyze) $(fpath "$INDIR/$SCRIPT.ts") --deterministic \
    >"$OUTDIR/$SCRIPT.tsanalyze.txt" \
    2>"$OUTDIR/$SCRIPT.tsanalyze.log"

test_text $SCRIPT.tsanalyze.txt
test_text $SCRIPT.tsanalyze.log

$(tspath tsanalyze) $(fpath "$INDIR/$SCRIPT.ts") --normalized --deterministic \
    >"$OUTDIR/$SCRIPT.tsanalyze.normalized.txt" \
    2>"$OUTDIR/$SCRIPT.tsanalyze.normalized.log"

test_text $SCRIPT.tsanalyze.normalized.txt
test_text $SCRIPT.tsanalyze.normalized.log
