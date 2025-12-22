#!/usr/bin/env bash
# tsflute

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
INFILE="$INDIR/test-198.ts"

# Prepare output directories.
(
    rm -rf "$TMPDIR/playlist.m3u8" "$TMPDIR/$SCRIPT.tmp"
    mkdir "$TMPDIR/$SCRIPT.tmp"
) >"$OUTDIR/$SCRIPT.init.log" 2>&1

test_text $SCRIPT.init.log

# Extract everything in one command.
test_tsp \
    -I file $(fpath "$INFILE") \
    -P flute --summary --output-file $(fpath "$OUTDIR/$SCRIPT.summary.txt") \
             --extract-file 'http://dvb.gw/eutelsat/ts_corp/73_aloula_w1dqfwm/playlist.m3u8' \
             --output-directory $(fpath "$TMPDIR/$SCRIPT.tmp") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_text $SCRIPT.tsp.log
test_text $SCRIPT.summary.txt

# Copy known extracted files.
(
    mv "$TMPDIR/$SCRIPT.tmp/playlist.m3u8" "$OUTDIR/$SCRIPT.out.1.m3u8"
    # Check that no additional file was extracted.
    find "$TMPDIR/$SCRIPT.tmp" -type f
    rm -rf "$TMPDIR/$SCRIPT.tmp"
) >"$OUTDIR/$SCRIPT.files.log" 2>&1

test_text $SCRIPT.files.log
test_bin $SCRIPT.out.1.m3u8
