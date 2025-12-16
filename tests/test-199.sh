#!/usr/bin/env bash
# tsflute

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
INFILE="$INDIR/test-197.pcap"

# Prepare output directories.
(
    rm -rf "$TMPDIR/5G-EMERGE.jpg" "$TMPDIR/$SCRIPT.tmp"
    mkdir "$TMPDIR/$SCRIPT.tmp"
) >"$OUTDIR/$SCRIPT.init.log" 2>&1

test_text $SCRIPT.init.log

# Extract everything in one command.
$(tspath tsflute) $(fpath "$INFILE") \
    --summary --output-file $(fpath "$OUTDIR/$SCRIPT.summary.txt") \
    --extract-file 'http://dvb.gw/ses.com/materials/5G-EMERGE.jpg' \
    --output-directory $(fpath "$TMPDIR/$SCRIPT.tmp") \
    >"$OUTDIR/$SCRIPT.tsflute.log" 2>&1

test_text $SCRIPT.tsflute.log
test_text $SCRIPT.summary.txt

# Copy known extracted files.
(
    mv "$TMPDIR/$SCRIPT.tmp/5G-EMERGE.jpg" "$OUTDIR/$SCRIPT.out.1.jpg"
    # Check that no additional file was extracted.
    find "$TMPDIR/$SCRIPT.tmp" -type f
    rm -rf "$TMPDIR/$SCRIPT.tmp"
) >"$OUTDIR/$SCRIPT.files.log" 2>&1

test_text $SCRIPT.files.log
test_bin $SCRIPT.out.1.jpg
