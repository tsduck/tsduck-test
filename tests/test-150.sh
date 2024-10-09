#!/usr/bin/env bash
# Test Teletext, Colors.

# input file preparation steps were:
#
# wget https://tsduck.io/streams/russia-t2mi-scte35/20180112_1129_UTC_Russian_mux1_T2MI_3PLPs_incl_SCTE35_in_PLP0.ts
# tsp -I file 20180112_1129_UTC_Russian_mux1_T2MI_3PLPs_incl_SCTE35_in_PLP0.ts -P t2mi --pid 0x1000 --plp 0 -P zap 0x0406 -O file srv0x0406.ts
# dd if=srv0x0406.ts of=test-150.ts bs=9999908 count=1 skip=1
#
# The results (different text colors) were confirmed using VLC 3.0.20 and ccextractor 0.94 (teletext page 888)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
source "$COMMONDIR"/standard-ts-test.sh $SCRIPT.ts

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P teletext --colors -o $(fpath "$OUTDIR/$SCRIPT.srt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.teletext.log" 2>&1

test_text $SCRIPT.teletext.log
test_text $SCRIPT.srt
