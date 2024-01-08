#!/usr/bin/env bash
# Test Teletext, Colors.

# input file preparation steps were:
#
# E-AC-3:
# download sample from https://sourceforge.net/p/mediainfo/bugs/1111/ (ffmpeg_eac3_bsmode_hi_2.ts)
# tsp -I file ffmpeg_eac3_bsmode_hi_2.ts -P filter -p 0 -p 0x1000 -p 0x103 -O file test-151.ts
#
# AC-3 sample is test-040.ts
#
# The results were confirmed using VLC 3.0.20 and ffplay 6.1 (sound works before and after atsc2dvb)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE_EAC3="$INDIR/$SCRIPT.ts"

test_tsp \
    -I file $(fpath "$INFILE_EAC3") \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.eac3.atsc.analyze.txt") \
    -P pmt --eac3-atsc2dvb \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.eac3.dvb.analyze.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.eac3.dvb.ts") \
    >"$OUTDIR/$SCRIPT.eac3.log" 2>&1

test_text $SCRIPT.eac3.log
test_text $SCRIPT.eac3.atsc.analyze.txt
test_text $SCRIPT.eac3.dvb.analyze.txt
test_bin $SCRIPT.eac3.dvb.ts

INFILE_AC3="$INDIR/test-040.ts"

test_tsp \
    -I file $(fpath "$INFILE_AC3") \
    -P filter -p 0x30 -p 0x34 -p 0 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.ac3.atsc.analyze.txt") \
    -P pmt --ac3-atsc2dvb \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.ac3.dvb.analyze.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.ac3.dvb.ts") \
    >"$OUTDIR/$SCRIPT.ac3.log" 2>&1

test_text $SCRIPT.ac3.log
test_text $SCRIPT.ac3.atsc.analyze.txt
test_text $SCRIPT.ac3.dvb.analyze.txt
test_bin $SCRIPT.ac3.dvb.ts
