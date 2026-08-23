#!/usr/bin/env bash
# Plugin spliceinject: event PTS close to wrap-down point (issue #1742)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp --verbose --add-input-stuffing 1/10 \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P spliceinject --service 1 --wait-first-batch --files $(fpath "$INDIR/$SCRIPT.xml") \
    -P filter --negate --pid 0x1FFF \
    -O file $(fpath "$OUTDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.log" 2>&1

# 1) Size of XML text file is different on Windows (CR-LF).
# 2) Order of file/spliceinject messages are not guaranteed.
sed -i \
    -e '/^\* spliceinject: loaded file .* bytes/d' \
    -e '/^\* file: initial input bitrate/d' \
    -e '/^\* file: creating file/d' \
    "$OUTDIR/$SCRIPT.log"

test_text $SCRIPT.log
test_bin $SCRIPT.ts
