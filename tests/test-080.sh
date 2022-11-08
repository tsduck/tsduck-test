#!/usr/bin/env bash
# Test Python bindings.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
native_only

$PYTHON $(fpath "$INDIR/$SCRIPT.py") $(fpath "$INDIR/test-001.ts") >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.log
