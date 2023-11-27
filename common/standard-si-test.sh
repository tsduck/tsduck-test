#!/usr/bin/env bash
# -----------------------------------------------------------------------------------
# Perform the "standard" set of tests on a PSI/SI XML file.
# Syntax: source "$COMMONDIR"/standard-si-test.sh input.xml [std-and-charset-options]
# -----------------------------------------------------------------------------------

INFILE="$INDIR/$1"
STDOPT=$2

# With tspacketize, we need the charset options but not the standard options.
PACKOPT=${STDOPT/--atsc/}
PACKOPT=${PACKOPT/--isdb/}
PACKOPT=${PACKOPT/--abnt/}

# ==== tstabcomp (compile)
$(trace $(tspath tstabcomp) $STDOPT \
    --compile $(fpath "$INFILE") \
    --output $(fpath "$OUTDIR/$SCRIPT.compile.bin"))
$(tspath tstabcomp) $STDOPT \
    --compile $(fpath "$INFILE") \
    --output $(fpath "$OUTDIR/$SCRIPT.compile.bin") \
    >"$OUTDIR/$SCRIPT.compile.log" 2>&1

test_bin $SCRIPT.compile.bin
test_text $SCRIPT.compile.log

# ==== tstabcomp (decompile)
$(trace $(tspath tstabcomp) $STDOPT \
    --decompile $(fpath "$OUTDIR/$SCRIPT.compile.bin") \
    --output $(fpath "$OUTDIR/$SCRIPT.decompile.xml"))
$(tspath tstabcomp) $STDOPT \
    --decompile $(fpath "$OUTDIR/$SCRIPT.compile.bin") \
    --output $(fpath "$OUTDIR/$SCRIPT.decompile.xml") \
    >"$OUTDIR/$SCRIPT.decompile.log" 2>&1

test_text $SCRIPT.decompile.xml
test_text $SCRIPT.decompile.log

$(trace $(tspath tstabcomp) --strict-xml $STDOPT \
    --decompile $(fpath "$OUTDIR/$SCRIPT.compile.bin") \
    --output $(fpath "$OUTDIR/$SCRIPT.decompile.strict.xml"))
$(tspath tstabcomp) --strict-xml $STDOPT \
    --decompile $(fpath "$OUTDIR/$SCRIPT.compile.bin") \
    --output $(fpath "$OUTDIR/$SCRIPT.decompile.strict.xml") \
    >"$OUTDIR/$SCRIPT.decompile.strict.log" 2>&1

test_text $SCRIPT.decompile.strict.xml
test_text $SCRIPT.decompile.strict.log

# ==== tstabcomp (JSON)
$(trace $(tspath tstabcomp) $STDOPT \
    --decompile $(fpath "$OUTDIR/$SCRIPT.compile.bin") \
    --output $(fpath "$OUTDIR/$SCRIPT.decompile.json"))
$(tspath tstabcomp) $STDOPT \
    --decompile $(fpath "$OUTDIR/$SCRIPT.compile.bin") \
    --output $(fpath "$OUTDIR/$SCRIPT.decompile.json") \
    >"$OUTDIR/$SCRIPT.decompile.json.log" 2>&1

test_text $SCRIPT.decompile.json
test_text $SCRIPT.decompile.json.log

$(trace $(tspath tstabcomp) $STDOPT \
    --compile $(fpath "$OUTDIR/$SCRIPT.decompile.json") \
    --output $(fpath "$OUTDIR/$SCRIPT.compile.json.bin"))
$(tspath tstabcomp) $STDOPT \
    --compile $(fpath "$OUTDIR/$SCRIPT.decompile.json") \
    --output $(fpath "$OUTDIR/$SCRIPT.compile.json.bin") \
    >"$OUTDIR/$SCRIPT.compile.json.log" 2>&1

test_bin $SCRIPT.compile.json.bin
test_text $SCRIPT.compile.json.log

cmp "$OUTDIR/$SCRIPT.compile.bin" "$OUTDIR/$SCRIPT.compile.json.bin" \
    >"$OUTDIR/$SCRIPT.cmp.json.log" 2>&1

test_text $SCRIPT.cmp.json.log

# ==== tspacketize
$(trace $(tspath tspacketize) $PACKOPT \
    $(fpath "$INFILE") --pid 200 \
    --output $(fpath "$OUTDIR/$SCRIPT.pack.ts"))
$(tspath tspacketize) $PACKOPT \
    $(fpath "$INFILE") --pid 200 \
    --output $(fpath "$OUTDIR/$SCRIPT.pack.ts") \
    >"$OUTDIR/$SCRIPT.pack.log" 2>&1

test_bin $SCRIPT.pack.ts
test_text $SCRIPT.pack.log

# ==== tstables, packetized file
$(trace $(tspath tstables) $(fpath "$OUTDIR/$SCRIPT.pack.ts") --invalid-sections $STDOPT \
    --text $(fpath "$OUTDIR/$SCRIPT.tstables.txt") \
    --xml $(fpath "$OUTDIR/$SCRIPT.tstables.xml"))
$(tspath tstables) $(fpath "$OUTDIR/$SCRIPT.pack.ts") --invalid-sections $STDOPT \
    --text $(fpath "$OUTDIR/$SCRIPT.tstables.txt") \
    --xml $(fpath "$OUTDIR/$SCRIPT.tstables.xml") \
    >"$OUTDIR/$SCRIPT.tstables.log" 2>&1

test_text $SCRIPT.tstables.txt
test_text $SCRIPT.tstables.xml
test_text $SCRIPT.tstables.log

$(trace $(tspath tstables) $(fpath "$OUTDIR/$SCRIPT.pack.ts") $STDOPT \
    --strict-xml --xml $(fpath "$OUTDIR/$SCRIPT.tstables.strict.xml"))
$(tspath tstables) $(fpath "$OUTDIR/$SCRIPT.pack.ts") $STDOPT \
    --strict-xml --xml $(fpath "$OUTDIR/$SCRIPT.tstables.strict.xml") \
    >"$OUTDIR/$SCRIPT.tstables.strict.log" 2>&1

test_text $SCRIPT.tstables.strict.xml
test_text $SCRIPT.tstables.strict.log

# ==== tstabdump
$(trace $(tspath tstabdump) $(fpath "$OUTDIR/$SCRIPT.compile.bin") $STDOPT)
$(tspath tstabdump) $(fpath "$OUTDIR/$SCRIPT.compile.bin") $STDOPT \
    >"$OUTDIR/$SCRIPT.tstabdump.txt" \
    2>"$OUTDIR/$SCRIPT.tstabdump.log"

test_text $SCRIPT.tstabdump.txt
test_text $SCRIPT.tstabdump.log
