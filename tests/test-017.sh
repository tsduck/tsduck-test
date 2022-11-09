#!/usr/bin/env bash
# Test the IP/MAC Notification Table (INT)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# ==== tstabcomp (decompile)

$(tspath tstabcomp) \
    --decompile $(fpath "$INDIR/$SCRIPT.int.bin") \
    --output $(fpath "$OUTDIR/$SCRIPT.decompile.xml") \
    >"$OUTDIR/$SCRIPT.decompile.log" 2>&1

test_text $SCRIPT.decompile.xml
test_text $SCRIPT.decompile.log

# ==== tstabcomp (compile)

$(tspath tstabcomp) \
    --compile $(fpath "$OUTDIR/$SCRIPT.decompile.xml") \
    --output $(fpath "$OUTDIR/$SCRIPT.compile.bin") \
    >"$OUTDIR/$SCRIPT.compile.log" 2>&1

test_bin $SCRIPT.compile.bin
test_text $SCRIPT.compile.log

# ==== tspacketize

$(tspath tspacketize) $(fpath "$INDIR/$SCRIPT.int.bin") --pid 200 --output $(fpath "$OUTDIR/$SCRIPT.pack.ts") \
    >"$OUTDIR/$SCRIPT.pack.log" 2>&1

test_bin $SCRIPT.pack.ts
test_text $SCRIPT.pack.log

# ==== tstables, packetized file

$(tspath tstables) $(fpath "$OUTDIR/$SCRIPT.pack.ts") \
    --text $(fpath "$OUTDIR/$SCRIPT.tstables.txt") \
    --xml $(fpath "$OUTDIR/$SCRIPT.tstables.xml") \
    >"$OUTDIR/$SCRIPT.tstables.log" 2>&1

test_text $SCRIPT.tstables.txt
test_text $SCRIPT.tstables.xml
test_text $SCRIPT.tstables.log

# ==== tstabdump

$(tspath tstabdump) $(fpath "$INDIR/$SCRIPT.int.bin") \
    >"$OUTDIR/$SCRIPT.tstabdump.txt" \
    2>"$OUTDIR/$SCRIPT.tstabdump.log"

test_text $SCRIPT.tstabdump.txt
test_text $SCRIPT.tstabdump.log
