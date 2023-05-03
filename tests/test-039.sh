#!/usr/bin/env bash
# Test multiple CW in text file for scrambler plugin.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P scrambler 0x0204 --atis-idsa --cw-file $(fpath "$INDIR/$SCRIPT.cw.txt") --cp-duration 3 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.atis.txt") \
    -P file $(fpath "$OUTDIR/$SCRIPT.atis.ts") \
    -P descrambler 0x0204 --atis-idsa --cw-file $(fpath "$INDIR/$SCRIPT.cw.txt") \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.clear.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.clear.ts") \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_bin $SCRIPT.atis.ts
test_bin $SCRIPT.clear.ts
test_text $SCRIPT.atis.txt
test_text $SCRIPT.clear.txt
test_text $SCRIPT.tsp.log

test_tsp \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P filter --pid 0x01A4 --pid 0x01AE \
    -O file $(fpath "$TMPDIR/$SCRIPT.in.ts") \
    >"$OUTDIR/$SCRIPT.tsp.in.log" 2>&1

test_tsp \
    -I file $(fpath "$OUTDIR/$SCRIPT.clear.ts") \
    -P filter --pid 0x01A4 --pid 0x01AE \
    -O file $(fpath "$TMPDIR/$SCRIPT.out.ts") \
    >"$OUTDIR/$SCRIPT.tsp.out.log" 2>&1

pushd "$TMPDIR" >/dev/null
$(tspath tscmp) --continue "$SCRIPT.in.ts" "$SCRIPT.out.ts" >"$OUTDIR/$SCRIPT.cmp.log" 2>&1
popd >/dev/null

test_text $SCRIPT.tsp.in.log
test_text $SCRIPT.tsp.out.log
test_text $SCRIPT.cmp.log
