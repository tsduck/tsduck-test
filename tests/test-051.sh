#!/bin/bash
# Analyze and convert EIT's from an ATSC live stream.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-040.ts"

# Extract tables in various forms.
$(tspath tstables) $(fpath "$INFILE") --tid 0xCB \
    --text "$OUTDIR/$SCRIPT.tstables.txt" \
    --xml "$OUTDIR/$SCRIPT.tstables.xml" \
    --bin "$OUTDIR/$SCRIPT.tstables.bin" \
    &>"$OUTDIR/$SCRIPT.tstables.log"

test_bin $SCRIPT.tstables.bin
test_text $SCRIPT.tstables.txt
test_text $SCRIPT.tstables.xml
test_text $SCRIPT.tstables.log

# Compile extracted XML.
$(tspath tstabcomp) \
    --compile $(fpath "$OUTDIR/$SCRIPT.tstables.xml") \
    --output $(fpath "$OUTDIR/$SCRIPT.compile.bin") \
    >"$OUTDIR/$SCRIPT.compile.log" 2>&1

test_bin $SCRIPT.compile.bin
test_text $SCRIPT.compile.log

# Decompile extracted binary.
$(tspath tstabcomp) \
    --decompile $(fpath "$OUTDIR/$SCRIPT.tstables.bin") \
    --output $(fpath "$OUTDIR/$SCRIPT.decompile.xml") \
    >"$OUTDIR/$SCRIPT.decompile.log" 2>&1

test_text $SCRIPT.decompile.xml
test_text $SCRIPT.decompile.log
