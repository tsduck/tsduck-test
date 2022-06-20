#!/bin/bash
# Test tscmp

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
INFILE="$INDIR/test-001.ts"
declare -i i=1

(
    $(tspath tsp) -I file $(fpath "$INFILE") -P until -p 100 -O file $(fpath "$TMPDIR/$SCRIPT.1a.ts")
    $(tspath tsp) -I file $(fpath "$INFILE") -p 100 -P until -p 1 -P craft --payload-patter DEADBEEF --no-repeat -O file -a $(fpath "$TMPDIR/$SCRIPT.1a.ts")
    $(tspath tsp) -I file $(fpath "$INFILE") -p 101 -P until -p 99 -O file -a $(fpath "$TMPDIR/$SCRIPT.1a.ts")
    $(tspath tsp) -I file $(fpath "$INFILE") -p 200 -P until -p 1 -P craft --payload-patter F00BAC --no-repeat -O file -a $(fpath "$TMPDIR/$SCRIPT.1a.ts")
    $(tspath tsp) -I file $(fpath "$INFILE") -p 201 -P until -p 99 -O file -a $(fpath "$TMPDIR/$SCRIPT.1a.ts")
    $(tspath tsp) -I file $(fpath "$INFILE") -P until -p 300 -O file $(fpath "$TMPDIR/$SCRIPT.1b.ts")

) >"$OUTDIR/$SCRIPT.$i.log" 2>&1
test_text $SCRIPT.$i.log
i=$i+1

$(tspath tscmp) $(fpath "$TMPDIR/$SCRIPT.1a.ts") $(fpath "$TMPDIR/$SCRIPT.1b.ts") \
    >"$OUTDIR/$SCRIPT.$i.log" 2>&1
test_text $SCRIPT.$i.log
i=$i+1

$(tspath tscmp) $(fpath "$TMPDIR/$SCRIPT.1a.ts") $(fpath "$TMPDIR/$SCRIPT.1b.ts") \
    --verbose --continue \
    >"$OUTDIR/$SCRIPT.$i.log" 2>&1
test_text $SCRIPT.$i.log
i=$i+1

$(tspath tscmp) $(fpath "$TMPDIR/$SCRIPT.1a.ts") $(fpath "$TMPDIR/$SCRIPT.1b.ts") \
    --json --continue \
    >"$OUTDIR/$SCRIPT.$i.log" 2>&1
test_text $SCRIPT.$i.log
i=$i+1

($(tspath tscmp) --quiet $(fpath "$TMPDIR/$SCRIPT.1a.ts") $(fpath "$TMPDIR/$SCRIPT.1a.ts") && echo true || echo false) \
    >"$OUTDIR/$SCRIPT.$i.log" 2>&1
test_text $SCRIPT.$i.log
i=$i+1

($(tspath tscmp) --quiet $(fpath "$TMPDIR/$SCRIPT.1a.ts") $(fpath "$TMPDIR/$SCRIPT.1b.ts") && echo true || echo false) \
    >"$OUTDIR/$SCRIPT.$i.log" 2>&1
test_text $SCRIPT.$i.log
i=$i+1
