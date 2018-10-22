#!/bin/bash
# ------------------------------------------------------------------------------
# Perform the "standard" set of tests on a PSI/SI XML file.
# Syntax: source "$COMMONDIR"/standard-si-test.sh input.xml
# ------------------------------------------------------------------------------

INFILE="$INDIR/$1"

# ==== tstabcomp (compile)

$(tspath tstabcomp) \
    --compile $(fpath "$INFILE") \
    --output $(fpath "$OUTDIR/$SCRIPT.compile.bin") \
    >"$OUTDIR/$SCRIPT.compile.log" 2>&1

test_bin $SCRIPT.compile.bin
test_text $SCRIPT.compile.log

# ==== tstabcomp (decompile)

$(tspath tstabcomp) \
    --decompile $(fpath "$OUTDIR/$SCRIPT.compile.bin") \
    --output $(fpath "$OUTDIR/$SCRIPT.decompile.xml") \
    >"$OUTDIR/$SCRIPT.decompile.log" 2>&1

test_text $SCRIPT.decompile.xml
test_text $SCRIPT.decompile.log

$(tspath tstabcomp) --strict-xml \
    --decompile $(fpath "$OUTDIR/$SCRIPT.compile.bin") \
    --output $(fpath "$OUTDIR/$SCRIPT.decompile.strict.xml") \
    >"$OUTDIR/$SCRIPT.decompile.strict.log" 2>&1

test_text $SCRIPT.decompile.strict.xml
test_text $SCRIPT.decompile.strict.log

# ==== tspacketize

$(tspath tspacketize) $(fpath "$INFILE") --pid 200 --output $(fpath "$OUTDIR/$SCRIPT.pack.ts") \
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

$(tspath tstables) $(fpath "$OUTDIR/$SCRIPT.pack.ts") \
    --strict-xml --xml $(fpath "$OUTDIR/$SCRIPT.tstables.strict.xml") \
    >"$OUTDIR/$SCRIPT.tstables.strict.log" 2>&1

test_text $SCRIPT.tstables.strict.xml
test_text $SCRIPT.tstables.strict.log

# ==== tstabdump

$(tspath tstabdump) $(fpath "$OUTDIR/$SCRIPT.compile.bin") \
    >"$OUTDIR/$SCRIPT.tstabdump.txt" \
    2>"$OUTDIR/$SCRIPT.tstabdump.log"

test_text $SCRIPT.tstabdump.txt
test_text $SCRIPT.tstabdump.log
