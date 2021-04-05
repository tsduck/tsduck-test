#!/bin/bash
# Test option --ignore-leap-seconds

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Without --ignore-leap-seconds

$(tspath tstabcomp) -c $(fpath "$INDIR/$SCRIPT.xml") -o $(fpath "$OUTDIR/$SCRIPT.comp.def.bin") \
    >"$OUTDIR/$SCRIPT.comp.def.log" 2>&1

test_text $SCRIPT.comp.def.log
test_bin $SCRIPT.comp.def.bin

$(tspath tstabdump) $(fpath "$OUTDIR/$SCRIPT.comp.def.bin") \
    >"$OUTDIR/$SCRIPT.dump.def.log" 2>&1

test_text $SCRIPT.dump.def.log

$(tspath tstabcomp) -d $(fpath "$OUTDIR/$SCRIPT.comp.def.bin") -o $(fpath "$OUTDIR/$SCRIPT.decomp.def.xml") \
    >"$OUTDIR/$SCRIPT.decomp.def.log" 2>&1

test_text $SCRIPT.decomp.def.log
test_text $SCRIPT.decomp.def.xml

# With --ignore-leap-seconds

$(tspath tstabcomp) -c $(fpath "$INDIR/$SCRIPT.xml") -o $(fpath "$OUTDIR/$SCRIPT.comp.ign.bin") \
    --ignore-leap-seconds >"$OUTDIR/$SCRIPT.comp.ign.log" 2>&1

test_text $SCRIPT.comp.ign.log
test_bin $SCRIPT.comp.ign.bin

$(tspath tstabdump) $(fpath "$OUTDIR/$SCRIPT.comp.ign.bin") \
    --ignore-leap-seconds >"$OUTDIR/$SCRIPT.dump.ign.log" 2>&1

test_text $SCRIPT.dump.ign.log

$(tspath tstabcomp) -d $(fpath "$OUTDIR/$SCRIPT.comp.ign.bin") -o $(fpath "$OUTDIR/$SCRIPT.decomp.ign.xml") \
    --ignore-leap-seconds >"$OUTDIR/$SCRIPT.decomp.ign.log" 2>&1

test_text $SCRIPT.decomp.ign.log
test_text $SCRIPT.decomp.ign.xml
