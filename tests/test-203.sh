#!/usr/bin/env bash
# Plugin dsmcc: Object Carousel extraction with raw module dumps

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
INFILE="$INDIR/$SCRIPT.ts"

# Prepare output directory.
(
    rm -rf "$TMPDIR/$SCRIPT.tmp"
    mkdir "$TMPDIR/$SCRIPT.tmp"
) >"$OUTDIR/$SCRIPT.init.log" 2>&1

test_text $SCRIPT.init.log

# Extract carousel objects and raw module payloads on the same run.
test_tsp \
    -I file $(fpath "$INFILE") \
    -P dsmcc --pid 0x76A \
             --output-directory $(fpath "$TMPDIR/$SCRIPT.tmp") \
             --dump-modules \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_text $SCRIPT.tsp.log

# Copy known extracted files and modules to the comparison area.
(
    mv "$TMPDIR/$SCRIPT.tmp/files/deja.ttf"   "$OUTDIR/$SCRIPT.file.deja.ttf"
    mv "$TMPDIR/$SCRIPT.tmp/files/index.html" "$OUTDIR/$SCRIPT.file.index.html"
    mv "$TMPDIR/$SCRIPT.tmp/files/rj45.gif"   "$OUTDIR/$SCRIPT.file.rj45.gif"
    mv "$TMPDIR/$SCRIPT.tmp/modules/module_0001.bin" "$OUTDIR/$SCRIPT.module_0001.bin"
    mv "$TMPDIR/$SCRIPT.tmp/modules/module_0002.bin" "$OUTDIR/$SCRIPT.module_0002.bin"
    mv "$TMPDIR/$SCRIPT.tmp/modules/module_0003.bin" "$OUTDIR/$SCRIPT.module_0003.bin"
    # Confirm nothing else was produced.
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
