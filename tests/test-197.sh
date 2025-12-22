#!/usr/bin/env bash
# tsnip

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Prepare output directories.
(
    rm -rf "$TMPDIR/5G-EMERGE.jpg" "$TMPDIR/$SCRIPT.tmp"
    mkdir "$TMPDIR/$SCRIPT.tmp"
) >"$OUTDIR/$SCRIPT.init.log" 2>&1

test_text $SCRIPT.init.log

# Extract everything in one command.
$(tspath tsnip) $(fpath "$INDIR/$SCRIPT.pcap") \
    --summary --output-file $(fpath "$OUTDIR/$SCRIPT.summary.txt") \
    --extract-file 'http://dvb.gw/ses.com/materials/5G-EMERGE.jpg' \
    --output-directory $(fpath "$TMPDIR/$SCRIPT.tmp") \
    --save-bootstrap $(fpath "$OUTDIR/$SCRIPT.bootstrap.xml") \
    --save-nif $(fpath "$OUTDIR/$SCRIPT.nif.xml") \
    --save-sif $(fpath "$OUTDIR/$SCRIPT.sif.xml") \
    --save-slep $(fpath "$OUTDIR/$SCRIPT.slep.xml") \
    --save-dvb-gw $(fpath "$TMPDIR/$SCRIPT.tmp") \
    >"$OUTDIR/$SCRIPT.tsnip.log" 2>&1

test_text $SCRIPT.tsnip.log
test_text $SCRIPT.summary.txt
test_text $SCRIPT.bootstrap.xml
test_text $SCRIPT.nif.xml
test_text $SCRIPT.sif.xml
test_text $SCRIPT.slep.xml

# Copy known extracted files.
(
    mv "$TMPDIR/$SCRIPT.tmp/5G-EMERGE.jpg" "$OUTDIR/$SCRIPT.out.1.jpg"
    mv "$TMPDIR/$SCRIPT.tmp/ses.com/materials/5G-EMERGE.jpg" "$OUTDIR/$SCRIPT.out.2.jpg"
    mv "$TMPDIR/$SCRIPT.tmp/ses.com/dvbi/cg/manifest.xml" "$OUTDIR/$SCRIPT.out.3.xml"
    mv "$TMPDIR/$SCRIPT.tmp/ses.com/dvbi/service_list_tp1045.xml" "$OUTDIR/$SCRIPT.out.4.xml"
    mv "$TMPDIR/$SCRIPT.tmp/ses.com/dvbi/service_list_full.xml" "$OUTDIR/$SCRIPT.out.5.xml"
    mv "$TMPDIR/$SCRIPT.tmp/ses.com/private/dvbi/service_list_ses_private.xml" "$OUTDIR/$SCRIPT.out.6.xml"
    # Check that no additional file was extracted.
    find "$TMPDIR/$SCRIPT.tmp" -type f
    rm -rf "$TMPDIR/$SCRIPT.tmp"
) >"$OUTDIR/$SCRIPT.files.log" 2>&1

test_text $SCRIPT.files.log
test_bin $SCRIPT.out.1.jpg
test_bin $SCRIPT.out.2.jpg
test_bin $SCRIPT.out.3.xml
test_bin $SCRIPT.out.4.xml
test_bin $SCRIPT.out.5.xml
test_bin $SCRIPT.out.6.xml
