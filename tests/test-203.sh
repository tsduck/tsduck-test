#!/usr/bin/env bash
# Plugin dsmcc: Object Carousel extraction with raw module dumps.
#  - test-203.1: Small Object Carousel (all modules < 1 MB)
#  - test-203.2: Large Object Carousel with a ~10 MB module spanning many DDB blocks

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

ORIG_SCRIPT=$SCRIPT

#--- Sub-test 1: Small Object Carousel -----------------

INFILE="$INDIR/$SCRIPT.1.ts"

# List mode — no extraction, just carousel summary.
test_tsp \
    -I file $(fpath "$INFILE") \
    -P dsmcc --pid 0x76A \
    -O drop \
    >"$OUTDIR/$SCRIPT.1.list.log" 2>&1

test_text $SCRIPT.1.list.log

# Extraction mode — extract files and raw module dumps.
(
    rm -rf "$TMPDIR/$SCRIPT.1.tmp"
    mkdir "$TMPDIR/$SCRIPT.1.tmp"
) >"$OUTDIR/$SCRIPT.1.init.log" 2>&1

test_text $SCRIPT.1.init.log

test_tsp \
    -I file $(fpath "$INFILE") \
    -P dsmcc --pid 0x76A \
             --output-directory $(fpath "$TMPDIR/$SCRIPT.1.tmp") \
             --dump-modules \
    -O drop \
    >"$OUTDIR/$SCRIPT.1.tsp.log" 2>&1

test_text $SCRIPT.1.tsp.log

(
    mv "$TMPDIR/$SCRIPT.1.tmp/files/deja.ttf"   "$OUTDIR/$SCRIPT.1.file.deja.ttf"
    mv "$TMPDIR/$SCRIPT.1.tmp/files/index.html" "$OUTDIR/$SCRIPT.1.file.index.html"
    mv "$TMPDIR/$SCRIPT.1.tmp/files/rj45.gif"   "$OUTDIR/$SCRIPT.1.file.rj45.gif"
    mv "$TMPDIR/$SCRIPT.1.tmp/modules/0000000A/module_0001.bin" "$OUTDIR/$SCRIPT.1.module_0001.bin"
    mv "$TMPDIR/$SCRIPT.1.tmp/modules/0000000A/module_0002.bin" "$OUTDIR/$SCRIPT.1.module_0002.bin"
    mv "$TMPDIR/$SCRIPT.1.tmp/modules/0000000A/module_0003.bin" "$OUTDIR/$SCRIPT.1.module_0003.bin"
    find "$TMPDIR/$SCRIPT.1.tmp" -type f
    rm -rf "$TMPDIR/$SCRIPT.1.tmp"
) >"$OUTDIR/$SCRIPT.1.files.log" 2>&1

test_text $SCRIPT.1.files.log
test_bin $SCRIPT.1.file.deja.ttf
test_bin $SCRIPT.1.file.index.html
test_bin $SCRIPT.1.file.rj45.gif
test_bin $SCRIPT.1.module_0001.bin
test_bin $SCRIPT.1.module_0002.bin
test_bin $SCRIPT.1.module_0003.bin

#--- Sub-test 2: large carousel (~10 MB module, multi-block assembly) ------

INFILE="$INDIR/$SCRIPT.2.ts"

# List mode — verify the carousel summary for the large stream.
test_tsp \
    -I file $(fpath "$INFILE") \
    -P dsmcc --pid 0x1038 \
    -O drop \
    >"$OUTDIR/$SCRIPT.2.list.log" 2>&1

test_text $SCRIPT.2.list.log

# Extraction mode — extract files and raw module dumps.
(
    rm -rf "$TMPDIR/$SCRIPT.2.tmp"
    mkdir "$TMPDIR/$SCRIPT.2.tmp"
) >"$OUTDIR/$SCRIPT.2.init.log" 2>&1

test_text $SCRIPT.2.init.log

test_tsp \
    -I file $(fpath "$INFILE") \
    -P dsmcc --pid 0x1038 \
             --output-directory $(fpath "$TMPDIR/$SCRIPT.2.tmp") \
             --dump-modules \
    -O drop \
    >"$OUTDIR/$SCRIPT.2.tsp.log" 2>&1

test_text $SCRIPT.2.tsp.log

(
    mv "$TMPDIR/$SCRIPT.2.tmp/files/programs.tgz"                "$OUTDIR/$SCRIPT.2.file.programs.tgz"
    mv "$TMPDIR/$SCRIPT.2.tmp/files/programs.tgz.prodkey0.sig"   "$OUTDIR/$SCRIPT.2.file.programs.tgz.prodkey0.sig"
    mv "$TMPDIR/$SCRIPT.2.tmp/files/programs.tgz.testkey0.sig"   "$OUTDIR/$SCRIPT.2.file.programs.tgz.testkey0.sig"
    mv "$TMPDIR/$SCRIPT.2.tmp/modules/0000002A/module_0001.bin"  "$OUTDIR/$SCRIPT.2.module_0001.bin"
    mv "$TMPDIR/$SCRIPT.2.tmp/modules/0000002A/module_0002.bin"  "$OUTDIR/$SCRIPT.2.module_0002.bin"
    mv "$TMPDIR/$SCRIPT.2.tmp/modules/0000002A/module_0003.bin"  "$OUTDIR/$SCRIPT.2.module_0003.bin"
    find "$TMPDIR/$SCRIPT.2.tmp" -type f
    rm -rf "$TMPDIR/$SCRIPT.2.tmp"
) >"$OUTDIR/$SCRIPT.2.files.log" 2>&1

test_text $SCRIPT.2.files.log
test_bin $SCRIPT.2.file.programs.tgz
test_bin $SCRIPT.2.file.programs.tgz.prodkey0.sig
test_bin $SCRIPT.2.file.programs.tgz.testkey0.sig
test_bin $SCRIPT.2.module_0001.bin
test_bin $SCRIPT.2.module_0002.bin
test_bin $SCRIPT.2.module_0003.bin

SCRIPT=$ORIG_SCRIPT
