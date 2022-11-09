#!/usr/bin/env bash
# Test --atsc option

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# TS file, MPEG table first, then ATSC

$(tspath tstables) $(fpath "$INDIR/$SCRIPT.pmtvct.ts") \
    >"$OUTDIR/$SCRIPT.tstables.pmtvct.txt" \
    2>"$OUTDIR/$SCRIPT.tstables.pmtvct.log"

test_text $SCRIPT.tstables.pmtvct.txt
test_text $SCRIPT.tstables.pmtvct.log

$(tspath tstables) $(fpath "$INDIR/$SCRIPT.pmtvct.ts") --atsc \
    >"$OUTDIR/$SCRIPT.tstables.pmtvct.atsc.txt" \
    2>"$OUTDIR/$SCRIPT.tstables.pmtvct.atsc.log"

test_text $SCRIPT.tstables.pmtvct.atsc.txt
test_text $SCRIPT.tstables.pmtvct.atsc.log

# TS file, ATSC table first, then MPEG

$(tspath tstables) $(fpath "$INDIR/$SCRIPT.vctpmt.ts") \
    >"$OUTDIR/$SCRIPT.tstables.vctpmt.txt" \
    2>"$OUTDIR/$SCRIPT.tstables.vctpmt.log"

test_text $SCRIPT.tstables.vctpmt.txt
test_text $SCRIPT.tstables.vctpmt.log

$(tspath tstables) $(fpath "$INDIR/$SCRIPT.vctpmt.ts") --atsc \
    >"$OUTDIR/$SCRIPT.tstables.vctpmt.atsc.txt" \
    2>"$OUTDIR/$SCRIPT.tstables.vctpmt.atsc.log"

test_text $SCRIPT.tstables.vctpmt.atsc.txt
test_text $SCRIPT.tstables.vctpmt.atsc.log

# Section file, PMT alone with ATSC descriptors

$(tspath tstabdump) $(fpath "$INDIR/$SCRIPT.pmt.bin") \
    >"$OUTDIR/$SCRIPT.tstabdump.pmt.txt" \
    2>"$OUTDIR/$SCRIPT.tstabdump.pmt.log"

test_text $SCRIPT.tstabdump.pmt.txt
test_text $SCRIPT.tstabdump.pmt.log

$(tspath tstabdump) $(fpath "$INDIR/$SCRIPT.pmt.bin") --atsc \
    >"$OUTDIR/$SCRIPT.tstabdump.pmt.atsc.txt" \
    2>"$OUTDIR/$SCRIPT.tstabdump.pmt.atsc.log"

test_text $SCRIPT.tstabdump.pmt.atsc.txt
test_text $SCRIPT.tstabdump.pmt.atsc.log

# Section file, PMT with ATSC descriptors, followed by ATSC table

$(tspath tstabdump) $(fpath "$INDIR/$SCRIPT.pmtvct.bin") \
    >"$OUTDIR/$SCRIPT.tstabdump.pmtvct.txt" \
    2>"$OUTDIR/$SCRIPT.tstabdump.pmtvct.log"

test_text $SCRIPT.tstabdump.pmtvct.txt
test_text $SCRIPT.tstabdump.pmtvct.log

$(tspath tstabdump) $(fpath "$INDIR/$SCRIPT.pmtvct.bin") --atsc \
    >"$OUTDIR/$SCRIPT.tstabdump.pmtvct.atsc.txt" \
    2>"$OUTDIR/$SCRIPT.tstabdump.pmtvct.atsc.log"

test_text $SCRIPT.tstabdump.pmtvct.atsc.txt
test_text $SCRIPT.tstabdump.pmtvct.atsc.log
