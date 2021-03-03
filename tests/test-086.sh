#!/bin/bash
# Test Python on memory plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
native_only

INFILE="$INDIR/test-001.ts"
OUTFILE="$TMPDIR/$SCRIPT.ts"

"$PYTHON" $(fpath "$INDIR/$SCRIPT.py") $(fpath "$INFILE") $(fpath "$OUTFILE") >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.log

# We don't store the output file. It is large and should be identical
# to the input one. So, we just store the result of the comparison.

$(tspath tscmp) --continue "$INFILE" "$OUTFILE" >"$OUTDIR/$SCRIPT.tscmp.log" 2>&1

test_text $SCRIPT.tscmp.log
