#!/usr/bin/env bash
# Plugin dsmcc: Object Carousel extraction with raw module dumps.
#  - test-203.1: Small Object Carousel (all modules < 1 MB)
#  - test-203.2: Large Object Carousel with a ~10 MB module spanning many DDB blocks

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

ORIG_SCRIPT=$SCRIPT

#--- Sub-test 1: Small Object Carousel -----------------

SCRIPT="$ORIG_SCRIPT.1"
INFILE="$INDIR/$SCRIPT.ts"

# List mode — no extraction, just carousel summary.
test_tsp \
    -I file $(fpath "$INFILE") \
    -P dsmcc --pid 0x76A \
    -O drop \
    >"$OUTDIR/$SCRIPT.list.log" 2>&1

test_text $SCRIPT.list.log

# Extraction mode — extract files and raw module dumps.
(
    rm -rf "$TMPDIR/$SCRIPT.tmp"
    mkdir "$TMPDIR/$SCRIPT.tmp"
) >"$OUTDIR/$SCRIPT.init.log" 2>&1

test_text $SCRIPT.init.log

test_tsp \
    -I file $(fpath "$INFILE") \
    -P dsmcc --pid 0x76A \
             --output-directory $(fpath "$TMPDIR/$SCRIPT.tmp") \
             --dump-modules \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_text $SCRIPT.tsp.log

(
    mv "$TMPDIR/$SCRIPT.tmp/files/deja.ttf"   "$OUTDIR/$SCRIPT.file.deja.ttf"
    mv "$TMPDIR/$SCRIPT.tmp/files/index.html" "$OUTDIR/$SCRIPT.file.index.html"
    mv "$TMPDIR/$SCRIPT.tmp/files/rj45.gif"   "$OUTDIR/$SCRIPT.file.rj45.gif"
    mv "$TMPDIR/$SCRIPT.tmp/modules/0000000A/module_0001.bin" "$OUTDIR/$SCRIPT.module_0001.bin"
    mv "$TMPDIR/$SCRIPT.tmp/modules/0000000A/module_0002.bin" "$OUTDIR/$SCRIPT.module_0002.bin"
    mv "$TMPDIR/$SCRIPT.tmp/modules/0000000A/module_0003.bin" "$OUTDIR/$SCRIPT.module_0003.bin"
    find "$TMPDIR/$SCRIPT.tmp" -type f
    rm -rf "$TMPDIR/$SCRIPT.tmp"
) >"$OUTDIR/$SCRIPT.files.log" 2>&1

test_text $SCRIPT.files.log
test_bin $SCRIPT.file.deja.ttf
test_bin $SCRIPT.file.index.html
test_bin $SCRIPT.file.rj45.gif
test_bin $SCRIPT.module_0001.bin
test_bin $SCRIPT.module_0002.bin
test_bin $SCRIPT.module_0003.bin

#--- Sub-test 2: large carousel (~10 MB module, multi-block assembly) ------

SCRIPT="$ORIG_SCRIPT.2"
INFILE="$INDIR/$SCRIPT.ts"

# List mode — verify the carousel summary for the large stream.
test_tsp \
    -I file $(fpath "$INFILE") \
    -P dsmcc --pid 0x1038 \
    -O drop \
    >"$OUTDIR/$SCRIPT.list.log" 2>&1

test_text $SCRIPT.list.log

# Extraction mode — extract files and raw module dumps.
(
    rm -rf "$TMPDIR/$SCRIPT.tmp"
    mkdir "$TMPDIR/$SCRIPT.tmp"
) >"$OUTDIR/$SCRIPT.init.log" 2>&1

test_text $SCRIPT.init.log

test_tsp \
    -I file $(fpath "$INFILE") \
    -P dsmcc --pid 0x1038 \
             --output-directory $(fpath "$TMPDIR/$SCRIPT.tmp") \
             --dump-modules \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_text $SCRIPT.tsp.log

(
    mv "$TMPDIR/$SCRIPT.tmp/files/programs.tgz"                "$OUTDIR/$SCRIPT.file.programs.tgz"
    mv "$TMPDIR/$SCRIPT.tmp/files/programs.tgz.prodkey0.sig"   "$OUTDIR/$SCRIPT.file.programs.tgz.prodkey0.sig"
    mv "$TMPDIR/$SCRIPT.tmp/files/programs.tgz.testkey0.sig"   "$OUTDIR/$SCRIPT.file.programs.tgz.testkey0.sig"
    mv "$TMPDIR/$SCRIPT.tmp/modules/0000002A/module_0001.bin"  "$OUTDIR/$SCRIPT.module_0001.bin"
    mv "$TMPDIR/$SCRIPT.tmp/modules/0000002A/module_0002.bin"  "$OUTDIR/$SCRIPT.module_0002.bin"
    mv "$TMPDIR/$SCRIPT.tmp/modules/0000002A/module_0003.bin"  "$OUTDIR/$SCRIPT.module_0003.bin"
    find "$TMPDIR/$SCRIPT.tmp" -type f
    rm -rf "$TMPDIR/$SCRIPT.tmp"
) >"$OUTDIR/$SCRIPT.files.log" 2>&1

test_text $SCRIPT.files.log
test_bin $SCRIPT.file.programs.tgz
test_bin $SCRIPT.file.programs.tgz.prodkey0.sig
test_bin $SCRIPT.file.programs.tgz.testkey0.sig
test_bin $SCRIPT.module_0001.bin
test_bin $SCRIPT.module_0002.bin
test_bin $SCRIPT.module_0003.bin

SCRIPT=$ORIG_SCRIPT
