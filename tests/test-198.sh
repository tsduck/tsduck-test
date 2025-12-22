#!/usr/bin/env bash
# tsnip

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Prepare output directories.
(
    rm -rf "$TMPDIR/playlist.m3u8" "$TMPDIR/$SCRIPT.tmp"
    mkdir "$TMPDIR/$SCRIPT.tmp"
) >"$OUTDIR/$SCRIPT.init.log" 2>&1

test_text $SCRIPT.init.log

# Extract everything in one command.
test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P nip --summary --output-file $(fpath "$OUTDIR/$SCRIPT.summary.txt") \
           --extract-file 'http://dvb.gw/eutelsat/ts_corp/73_aloula_w1dqfwm/playlist.m3u8' \
           --output-directory $(fpath "$TMPDIR/$SCRIPT.tmp") \
           --save-bootstrap $(fpath "$OUTDIR/$SCRIPT.bootstrap.xml") \
           --save-nif $(fpath "$OUTDIR/$SCRIPT.nif.xml") \
           --save-sif $(fpath "$OUTDIR/$SCRIPT.sif.xml") \
           --save-dvb-gw $(fpath "$TMPDIR/$SCRIPT.tmp") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_text $SCRIPT.tsp.log
test_text $SCRIPT.summary.txt
test_text $SCRIPT.bootstrap.xml
test_text $SCRIPT.nif.xml
test_text $SCRIPT.sif.xml

# Copy known extracted files.
(
    mv "$TMPDIR/$SCRIPT.tmp/playlist.m3u8" "$OUTDIR/$SCRIPT.out.1.m3u8"
    mv "$TMPDIR/$SCRIPT.tmp/eutelsat/bpk-tv/orp01-ten999-ch007/hls-sb/index.m3u8" "$OUTDIR/$SCRIPT.out.2.m3u8"
    mv "$TMPDIR/$SCRIPT.tmp/eutelsat/bpk-tv/orp01-ten999-ch008/hls-sb/index.m3u8" "$OUTDIR/$SCRIPT.out.3.m3u8"
    mv "$TMPDIR/$SCRIPT.tmp/eutelsat/bpk-tv/orp01-ten999-ch009/hls-sb/index.m3u8" "$OUTDIR/$SCRIPT.out.4.m3u8"
    mv "$TMPDIR/$SCRIPT.tmp/eutelsat/corp/73_arryadia_k2tgcj0_480p/playlist.m3u8" "$OUTDIR/$SCRIPT.out.5.m3u8"
    mv "$TMPDIR/$SCRIPT.tmp/eutelsat/ts_corp/73_almaghribia_83tz85q/playlist.m3u8" "$OUTDIR/$SCRIPT.out.6.m3u8"
    mv "$TMPDIR/$SCRIPT.tmp/eutelsat/ts_corp/73_aloula_w1dqfwm/playlist.m3u8" "$OUTDIR/$SCRIPT.out.7.m3u8"
    # Check that no additional file was extracted.
    find "$TMPDIR/$SCRIPT.tmp" -type f
    rm -rf "$TMPDIR/$SCRIPT.tmp"
) >"$OUTDIR/$SCRIPT.files.log" 2>&1

test_text $SCRIPT.files.log
test_bin $SCRIPT.out.1.m3u8
test_bin $SCRIPT.out.2.m3u8
test_bin $SCRIPT.out.3.m3u8
test_bin $SCRIPT.out.4.m3u8
test_bin $SCRIPT.out.5.m3u8
test_bin $SCRIPT.out.6.m3u8
test_bin $SCRIPT.out.7.m3u8
