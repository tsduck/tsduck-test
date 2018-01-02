#!/bin/bash
# Test various analyses on live stream containing T2-MI encapsulation.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Standard stream analysis test.
source "$COMMONDIR"/standard-ts-test.sh test-003.ts

# T2-MI extraction.
$(tspath tsp) \
    -I file $(fpath "$INDIR/test-003.ts") \
    -P t2mi --pid 0x40 --extract \
    -O file $(fpath "$OUTDIR/$SCRIPT.t2mi.extracted.ts") \
    >"$OUTDIR/$SCRIPT.t2mi.log" 2>&1

test_text $SCRIPT.t2mi.log
test_bin $SCRIPT.t2mi.extracted.ts
