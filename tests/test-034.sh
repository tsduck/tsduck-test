#!/bin/bash
# Basic tests on tsswitch.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE1="$INDIR/test-023a.ts"
INFILE2="$INDIR/test-023b.ts"
INFILE3="$INDIR/test-023c.ts"

# URL of test patterns at tsduck.io:
TESTURL=https://tsduck.io/streams/test-patterns

# Simple file concatenation.
$(tspath tsswitch) --synchronous-log \
    -I file $(fpath "$INFILE1") \
    -I file $(fpath "$INFILE2") \
    -I file $(fpath "$INFILE3") \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_bin $SCRIPT.1.ts
test_text $SCRIPT.1.log

# Same with two cycles.
$(tspath tsswitch) --synchronous-log --cycle 2 \
    -I file $(fpath "$INFILE1") \
    -I file $(fpath "$INFILE2") \
    -I file $(fpath "$INFILE3") \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_bin $SCRIPT.2.ts
test_text $SCRIPT.2.log

# Same with created processes.
$(tspath tsswitch) --synchronous-log --cycle 2 \
    -I fork "$(fpath $(tspath tsp)) -I file "$(fpath "$INFILE1") \
    -I fork "$(fpath $(tspath tsp)) -I file "$(fpath "$INFILE2") \
    -I fork "$(fpath $(tspath tsp)) -I file "$(fpath "$INFILE3") \
    -O file $(fpath "$OUTDIR/$SCRIPT.3.ts") \
    >"$OUTDIR/$SCRIPT.3.log" 2>&1

test_bin $SCRIPT.3.ts
test_text $SCRIPT.3.log

# Same with HTTPS files (requires network access to tsduck.io).
$(tspath tsswitch) --synchronous-log --cycle 2 \
    -I http $TESTURL/test-1packet-01.ts \
    -I http $TESTURL/test-2packets-02-03.ts \
    -I http $TESTURL/test-3packets-04-05-06.ts \
    -O file $(fpath "$OUTDIR/$SCRIPT.4.ts") \
    >"$OUTDIR/$SCRIPT.4.log" 2>&1

test_bin $SCRIPT.4.ts
test_text $SCRIPT.4.log
