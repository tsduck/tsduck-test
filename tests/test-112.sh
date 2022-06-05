#!/bin/bash
# Test tstables with options --no-duplicate and --invalid-version

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tspacketize) $(fpath "$INDIR/$SCRIPT.1.xml") \
                      --pid 100 --stuffing \
                      --out $(fpath "$OUTDIR/$SCRIPT.1.ts") \
                      >"$OUTDIR/$SCRIPT.tspacketize.1.log" 2>&1

test_bin $SCRIPT.1.ts
test_text $SCRIPT.tspacketize.1.log

$(tspath tstables) $(fpath "$OUTDIR/$SCRIPT.1.ts") --packet-index --verbose \
                   --bin $(fpath "$OUTDIR/$SCRIPT.1a.bin") \
                   --text $(fpath "$OUTDIR/$SCRIPT.1a.txt") \
                   --xml $(fpath "$OUTDIR/$SCRIPT.1a.xml") \
                   >"$OUTDIR/$SCRIPT.tstables.1a.log" 2>&1

test_bin $SCRIPT.1a.bin
test_text $SCRIPT.1a.txt
test_text $SCRIPT.1a.xml
test_text $SCRIPT.tstables.1a.log

$(tspath tstables) $(fpath "$OUTDIR/$SCRIPT.1.ts") --packet-index --no-duplicate --verbose \
                   --bin $(fpath "$OUTDIR/$SCRIPT.1b.bin") \
                   --text $(fpath "$OUTDIR/$SCRIPT.1b.txt") \
                   --xml $(fpath "$OUTDIR/$SCRIPT.1b.xml") \
                   >"$OUTDIR/$SCRIPT.tstables.1b.log" 2>&1

test_bin $SCRIPT.1b.bin
test_text $SCRIPT.1b.txt
test_text $SCRIPT.1b.xml
test_text $SCRIPT.tstables.1b.log

$(tspath tspacketize) $(fpath "$INDIR/$SCRIPT.2.xml") \
                      --pid 100 --stuffing \
                      --out $(fpath "$OUTDIR/$SCRIPT.2.ts") \
                      >"$OUTDIR/$SCRIPT.tspacketize.2.log" 2>&1

test_bin $SCRIPT.2.ts
test_text $SCRIPT.tspacketize.2.log

$(tspath tstables) $(fpath "$OUTDIR/$SCRIPT.2.ts") --packet-index --verbose \
                   --bin $(fpath "$OUTDIR/$SCRIPT.2a.bin") \
                   --text $(fpath "$OUTDIR/$SCRIPT.2a.txt") \
                   --xml $(fpath "$OUTDIR/$SCRIPT.2a.xml") \
                   >"$OUTDIR/$SCRIPT.tstables.2a.log" 2>&1

test_bin $SCRIPT.2a.bin
test_text $SCRIPT.2a.txt
test_text $SCRIPT.2a.xml
test_text $SCRIPT.tstables.2a.log

$(tspath tstables) $(fpath "$OUTDIR/$SCRIPT.2.ts") --packet-index --invalid-versions --verbose \
                   --bin $(fpath "$OUTDIR/$SCRIPT.2b.bin") \
                   --text $(fpath "$OUTDIR/$SCRIPT.2b.txt") \
                   --xml $(fpath "$OUTDIR/$SCRIPT.2b.xml") \
                   >"$OUTDIR/$SCRIPT.tstables.2b.log" 2>&1

test_bin $SCRIPT.2b.bin
test_text $SCRIPT.2b.txt
test_text $SCRIPT.2b.xml
test_text $SCRIPT.tstables.2b.log
