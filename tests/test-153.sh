#!/usr/bin/env bash
# aes plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
INFILE="$INDIR/test-072.ts"
KEY=E77B17CBCF48F77140DC5B0B2BF322B6
IV=286132BC6D1CE5EC5BE931A934577B8A

test_tsp \
    -I file $(fpath "$INFILE") \
    -P filter --pid 0x0065 \
    -P until --packet 1000 \
    -P aes --key $KEY --iv $IV --cbc \
    -O file $(fpath "$OUTDIR/$SCRIPT.cbc.ts") \
    >"$OUTDIR/$SCRIPT.cbc.log" 2>&1

test_text $SCRIPT.cbc.log
test_bin $SCRIPT.cbc.ts

test_tsp \
    -I file $(fpath "$INFILE") \
    -P filter --pid 0x0065 \
    -P until --packet 1000 \
    -P aes --key $KEY --iv $IV --cts1 \
    -O file $(fpath "$OUTDIR/$SCRIPT.cts1.ts") \
    >"$OUTDIR/$SCRIPT.cts1.log" 2>&1

test_text $SCRIPT.cts1.log
test_bin $SCRIPT.cts1.ts

test_tsp \
    -I file $(fpath "$INFILE") \
    -P filter --pid 0x0065 \
    -P until --packet 1000 \
    -P aes --key $KEY --iv $IV --cts2 \
    -O file $(fpath "$OUTDIR/$SCRIPT.cts2.ts") \
    >"$OUTDIR/$SCRIPT.cts2.log" 2>&1

test_text $SCRIPT.cts2.log
test_bin $SCRIPT.cts2.ts

test_tsp \
    -I file $(fpath "$INFILE") \
    -P filter --pid 0x0065 \
    -P until --packet 1000 \
    -P aes --key $KEY --cts3 \
    -O file $(fpath "$OUTDIR/$SCRIPT.cts3.ts") \
    >"$OUTDIR/$SCRIPT.cts3.log" 2>&1

test_text $SCRIPT.cts3.log
test_bin $SCRIPT.cts3.ts

test_tsp \
    -I file $(fpath "$INFILE") \
    -P filter --pid 0x0065 \
    -P until --packet 1000 \
    -P aes --key $KEY --cts4 \
    -O file $(fpath "$OUTDIR/$SCRIPT.cts4.ts") \
    >"$OUTDIR/$SCRIPT.cts4.log" 2>&1

test_text $SCRIPT.cts4.log
test_bin $SCRIPT.cts4.ts

test_tsp \
    -I file $(fpath "$INFILE") \
    -P filter --pid 0x0065 \
    -P until --packet 1000 \
    -P aes --key $KEY --iv $IV --dvs042 \
    -O file $(fpath "$OUTDIR/$SCRIPT.dvs042.ts") \
    >"$OUTDIR/$SCRIPT.dvs042.log" 2>&1

test_text $SCRIPT.dvs042.log
test_bin $SCRIPT.dvs042.ts

test_tsp \
    -I file $(fpath "$INFILE") \
    -P filter --pid 0x0065 \
    -P until --packet 1000 \
    -P aes --key $KEY --ecb \
    -O file $(fpath "$OUTDIR/$SCRIPT.ecb.ts") \
    >"$OUTDIR/$SCRIPT.ecb.log" 2>&1

test_text $SCRIPT.ecb.log
test_bin $SCRIPT.ecb.ts

# Extract reference data for descrambling phase.
test_tsp \
    -I file $(fpath "$INFILE") \
    -P filter --pid 0x0065 \
    -P until --packet 1000 \
    -O file $(fpath "$TMPDIR/$SCRIPT.ref.ts") \
    >"$OUTDIR/$SCRIPT.ref.log" 2>&1

test_text $SCRIPT.ref.log

test_tsp \
    -I file $(fpath "$OUTDIR/$SCRIPT.cbc.ts") \
    -P aes --descramble --key $KEY --iv $IV --cbc \
    -O file $(fpath "$TMPDIR/$SCRIPT.cbc.clear.ts") \
    >"$OUTDIR/$SCRIPT.cbc.clear.log" 2>&1

test_text $SCRIPT.cbc.clear.log

$(tspath tscmp) --continue $(fpath "$TMPDIR/$SCRIPT.ref.ts") $(fpath "$TMPDIR/$SCRIPT.cbc.clear.ts") \
    >"$OUTDIR/$SCRIPT.cbc.cmp.log" 2>&1

test_text $SCRIPT.cbc.cmp.log

test_tsp \
    -I file $(fpath "$OUTDIR/$SCRIPT.cts1.ts") \
    -P aes --descramble --key $KEY --iv $IV --cts1 \
    -O file $(fpath "$TMPDIR/$SCRIPT.cts1.clear.ts") \
    >"$OUTDIR/$SCRIPT.cts1.clear.log" 2>&1

test_text $SCRIPT.cts1.clear.log

$(tspath tscmp) --continue $(fpath "$TMPDIR/$SCRIPT.ref.ts") $(fpath "$TMPDIR/$SCRIPT.cts1.clear.ts") \
    >"$OUTDIR/$SCRIPT.cts1.cmp.log" 2>&1

test_text $SCRIPT.cts1.cmp.log

test_tsp \
    -I file $(fpath "$OUTDIR/$SCRIPT.cts2.ts") \
    -P aes --descramble --key $KEY --iv $IV --cts2 \
    -O file $(fpath "$TMPDIR/$SCRIPT.cts2.clear.ts") \
    >"$OUTDIR/$SCRIPT.cts2.clear.log" 2>&1

test_text $SCRIPT.cts2.clear.log

$(tspath tscmp) --continue $(fpath "$TMPDIR/$SCRIPT.ref.ts") $(fpath "$TMPDIR/$SCRIPT.cts2.clear.ts") \
    >"$OUTDIR/$SCRIPT.cts2.cmp.log" 2>&1

test_text $SCRIPT.cts2.cmp.log

test_tsp \
    -I file $(fpath "$OUTDIR/$SCRIPT.cts3.ts") \
    -P aes --descramble --key $KEY --cts3 \
    -O file $(fpath "$TMPDIR/$SCRIPT.cts3.clear.ts") \
    >"$OUTDIR/$SCRIPT.cts3.clear.log" 2>&1

test_text $SCRIPT.cts3.clear.log

$(tspath tscmp) --continue $(fpath "$TMPDIR/$SCRIPT.ref.ts") $(fpath "$TMPDIR/$SCRIPT.cts3.clear.ts") \
    >"$OUTDIR/$SCRIPT.cts3.cmp.log" 2>&1

test_text $SCRIPT.cts3.cmp.log

test_tsp \
    -I file $(fpath "$OUTDIR/$SCRIPT.cts4.ts") \
    -P aes --descramble --key $KEY --cts4 \
    -O file $(fpath "$TMPDIR/$SCRIPT.cts4.clear.ts") \
    >"$OUTDIR/$SCRIPT.cts4.clear.log" 2>&1

test_text $SCRIPT.cts4.clear.log

$(tspath tscmp) --continue $(fpath "$TMPDIR/$SCRIPT.ref.ts") $(fpath "$TMPDIR/$SCRIPT.cts4.clear.ts") \
    >"$OUTDIR/$SCRIPT.cts4.cmp.log" 2>&1

test_text $SCRIPT.cts4.cmp.log

test_tsp \
    -I file $(fpath "$OUTDIR/$SCRIPT.dvs042.ts") \
    -P aes --descramble --key $KEY --iv $IV --dvs042 \
    -O file $(fpath "$TMPDIR/$SCRIPT.dvs042.clear.ts") \
    >"$OUTDIR/$SCRIPT.dvs042.clear.log" 2>&1

test_text $SCRIPT.dvs042.clear.log

$(tspath tscmp) --continue $(fpath "$TMPDIR/$SCRIPT.ref.ts") $(fpath "$TMPDIR/$SCRIPT.dvs042.clear.ts") \
    >"$OUTDIR/$SCRIPT.dvs042.cmp.log" 2>&1

test_text $SCRIPT.dvs042.cmp.log

test_tsp \
    -I file $(fpath "$OUTDIR/$SCRIPT.ecb.ts") \
    -P aes --descramble --key $KEY --ecb \
    -O file $(fpath "$TMPDIR/$SCRIPT.ecb.clear.ts") \
    >"$OUTDIR/$SCRIPT.ecb.clear.log" 2>&1

test_text $SCRIPT.ecb.clear.log

$(tspath tscmp) --continue $(fpath "$TMPDIR/$SCRIPT.ref.ts") $(fpath "$TMPDIR/$SCRIPT.ecb.clear.ts") \
    >"$OUTDIR/$SCRIPT.ecb.cmp.log" 2>&1

test_text $SCRIPT.ecb.cmp.log
