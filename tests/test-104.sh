#!/usr/bin/env bash
# Non-regression test on EIT Schedule generation.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tseit) --verbose --input-directory $(fpath "$INDIR") --output-directory $(fpath "$OUTDIR") \
    -c "set --ts-id 1 --ts-bitrate 14,518,747 --eit-bitrate 451,200 --terrestrial" \
    -c "set --time 2021/08/07:15:30:00.000" \
    -c "load $SCRIPT.xml" \
    -c "save $SCRIPT.1.bin" \
    -c "generate --seconds 35 -" \
    -c "save $SCRIPT.2.bin" 2>"$OUTDIR/$SCRIPT.tseit.log" |
$(tspath tstables) --all-sections --no-duplicate --pid 0x12 --packet-index \
    --text $(fpath "$OUTDIR/$SCRIPT.tstables.txt") \
    >"$OUTDIR/$SCRIPT.tstables.log" 2>&1

test_bin $SCRIPT.1.bin
test_bin $SCRIPT.2.bin
test_text $SCRIPT.tseit.log
test_text $SCRIPT.tstables.txt
test_text $SCRIPT.tstables.log
