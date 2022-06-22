#!/bin/bash
# Test tscmp

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
INFILE="$INDIR/test-001.ts"

# Create two 300-packets files with differing packets at offsets 100 and 200.
(
    $(tspath tsp) -I file $(fpath "$INFILE") -P until -p 100 -O file $(fpath "$TMPDIR/$SCRIPT.1a.ts")
    $(tspath tsp) -I file $(fpath "$INFILE") -p 100 -P until -p 1 -P craft --payload-patter DEADBEEF --no-repeat -O file -a $(fpath "$TMPDIR/$SCRIPT.1a.ts")
    $(tspath tsp) -I file $(fpath "$INFILE") -p 101 -P until -p 99 -O file -a $(fpath "$TMPDIR/$SCRIPT.1a.ts")
    $(tspath tsp) -I file $(fpath "$INFILE") -p 200 -P until -p 1 -P craft --payload-patter F00BAC --no-repeat -O file -a $(fpath "$TMPDIR/$SCRIPT.1a.ts")
    $(tspath tsp) -I file $(fpath "$INFILE") -p 201 -P until -p 99 -O file -a $(fpath "$TMPDIR/$SCRIPT.1a.ts")

    $(tspath tsp) -I file $(fpath "$INFILE") -P until -p 300 -O file $(fpath "$TMPDIR/$SCRIPT.1b.ts")

) >"$OUTDIR/$SCRIPT.prep.1.log" 2>&1
test_text $SCRIPT.prep.1.log

# Create two files with two holes at offsets 100 and 200, alternating files.
# The actual result is two 290-packets files and the second hole is at offset 190.
(
    $(tspath tsp) -I file $(fpath "$INFILE") -P until -p 100 -O file $(fpath "$TMPDIR/$SCRIPT.2a.ts")
    $(tspath tsp) -I file $(fpath "$INFILE") -p 110 -P until -p 190 -O file -a $(fpath "$TMPDIR/$SCRIPT.2a.ts")

    $(tspath tsp) -I file $(fpath "$INFILE") -P until -p 200 -O file $(fpath "$TMPDIR/$SCRIPT.2b.ts")
    $(tspath tsp) -I file $(fpath "$INFILE") -p 210 -P until -p 90 -O file -a $(fpath "$TMPDIR/$SCRIPT.2b.ts")

) >"$OUTDIR/$SCRIPT.prep.2.log" 2>&1
test_text $SCRIPT.prep.2.log

# Create two 300-packets files with two inverted chunks of packets, just like inverted UDP datagrams.
(
    $(tspath tsp) -I file $(fpath "$INFILE") -P until -p 100 -O file $(fpath "$TMPDIR/$SCRIPT.3a.ts")
    $(tspath tsp) -I file $(fpath "$INFILE") -p 107 -P until -p 14 -O file -a $(fpath "$TMPDIR/$SCRIPT.3a.ts")
    $(tspath tsp) -I file $(fpath "$INFILE") -p 100 -P until -p 7 -O file -a $(fpath "$TMPDIR/$SCRIPT.3a.ts")
    $(tspath tsp) -I file $(fpath "$INFILE") -p 121 -P until -p 179 -O file -a $(fpath "$TMPDIR/$SCRIPT.3a.ts")

    $(tspath tsp) -I file $(fpath "$INFILE") -P until -p 200 -O file $(fpath "$TMPDIR/$SCRIPT.3b.ts")
    $(tspath tsp) -I file $(fpath "$INFILE") -p 207 -P until -p 14 -O file -a $(fpath "$TMPDIR/$SCRIPT.3b.ts")
    $(tspath tsp) -I file $(fpath "$INFILE") -p 200 -P until -p 7 -O file -a $(fpath "$TMPDIR/$SCRIPT.3b.ts")
    $(tspath tsp) -I file $(fpath "$INFILE") -p 221 -P until -p 79 -O file -a $(fpath "$TMPDIR/$SCRIPT.3b.ts")

) >"$OUTDIR/$SCRIPT.prep.3.log" 2>&1
test_text $SCRIPT.prep.3.log

# Create a 200-packets file and a truncated one.
(
    $(tspath tsp) -I file $(fpath "$INFILE") -P until -p 200 -O file $(fpath "$TMPDIR/$SCRIPT.4a.ts")
    $(tspath tsp) -I file $(fpath "$INFILE") -P until -p 120 -O file $(fpath "$TMPDIR/$SCRIPT.4b.ts")

) >"$OUTDIR/$SCRIPT.prep.4.log" 2>&1
test_text $SCRIPT.prep.4.log

# Create a 200-packets file and a truncated one at the beginning.
(
    $(tspath tsp) -I file $(fpath "$INFILE") -P until -p 200 -O file $(fpath "$TMPDIR/$SCRIPT.5a.ts")
    $(tspath tsp) -I file $(fpath "$INFILE") -p 80 -P until -p 120 -O file $(fpath "$TMPDIR/$SCRIPT.5b.ts")

) >"$OUTDIR/$SCRIPT.prep.5.log" 2>&1
test_text $SCRIPT.prep.5.log

# Individual tests.
$(tspath tscmp) $(fpath "$TMPDIR/$SCRIPT.1a.ts") $(fpath "$TMPDIR/$SCRIPT.1b.ts") \
    >"$OUTDIR/$SCRIPT.01.log" 2>&1
test_text $SCRIPT.01.log

$(tspath tscmp) $(fpath "$TMPDIR/$SCRIPT.1a.ts") $(fpath "$TMPDIR/$SCRIPT.1b.ts") \
    --verbose --continue \
    >"$OUTDIR/$SCRIPT.02.log" 2>&1
test_text $SCRIPT.02.log

$(tspath tscmp) $(fpath "$TMPDIR/$SCRIPT.1a.ts") $(fpath "$TMPDIR/$SCRIPT.1b.ts") \
    --json --continue \
    >"$OUTDIR/$SCRIPT.03.log" 2>&1
test_text $SCRIPT.03.log

($(tspath tscmp) --quiet $(fpath "$TMPDIR/$SCRIPT.1a.ts") $(fpath "$TMPDIR/$SCRIPT.1a.ts") && echo true || echo false) \
    >"$OUTDIR/$SCRIPT.04.log" 2>&1
test_text $SCRIPT.04.log

($(tspath tscmp) --quiet $(fpath "$TMPDIR/$SCRIPT.1a.ts") $(fpath "$TMPDIR/$SCRIPT.1b.ts") && echo true || echo false) \
    >"$OUTDIR/$SCRIPT.05.log" 2>&1
test_text $SCRIPT.05.log

$(tspath tscmp) $(fpath "$TMPDIR/$SCRIPT.1a.ts") $(fpath "$TMPDIR/$SCRIPT.1b.ts") \
    --dump --continue \
    >"$OUTDIR/$SCRIPT.06.log" 2>&1
test_text $SCRIPT.06.log

$(tspath tscmp) $(fpath "$TMPDIR/$SCRIPT.4a.ts") $(fpath "$TMPDIR/$SCRIPT.4b.ts") \
    >"$OUTDIR/$SCRIPT.07.log" 2>&1
test_text $SCRIPT.07.log

$(tspath tscmp) $(fpath "$TMPDIR/$SCRIPT.4b.ts") $(fpath "$TMPDIR/$SCRIPT.4a.ts") \
    --verbose --continue \
    >"$OUTDIR/$SCRIPT.08.log" 2>&1
test_text $SCRIPT.08.log

$(tspath tscmp) $(fpath "$TMPDIR/$SCRIPT.4a.ts") $(fpath "$TMPDIR/$SCRIPT.4b.ts") \
    --json --continue \
    >"$OUTDIR/$SCRIPT.09.log" 2>&1
test_text $SCRIPT.09.log

$(tspath tscmp) $(fpath "$TMPDIR/$SCRIPT.2a.ts") $(fpath "$TMPDIR/$SCRIPT.2b.ts") \
    --search-reorder \
    >"$OUTDIR/$SCRIPT.10.log" 2>&1
test_text $SCRIPT.10.log

$(tspath tscmp) $(fpath "$TMPDIR/$SCRIPT.2a.ts") $(fpath "$TMPDIR/$SCRIPT.2b.ts") \
    --search-reorder --verbose --continue \
    >"$OUTDIR/$SCRIPT.11.log" 2>&1
test_text $SCRIPT.11.log

$(tspath tscmp) $(fpath "$TMPDIR/$SCRIPT.2a.ts") $(fpath "$TMPDIR/$SCRIPT.2b.ts") \
    --search-reorder --json --continue \
    >"$OUTDIR/$SCRIPT.12.log" 2>&1
test_text $SCRIPT.12.log

$(tspath tscmp) $(fpath "$TMPDIR/$SCRIPT.3a.ts") $(fpath "$TMPDIR/$SCRIPT.3b.ts") \
    --search-reorder \
    >"$OUTDIR/$SCRIPT.13.log" 2>&1
test_text $SCRIPT.13.log

$(tspath tscmp) $(fpath "$TMPDIR/$SCRIPT.3a.ts") $(fpath "$TMPDIR/$SCRIPT.3b.ts") \
    --search-reorder --verbose --continue \
    >"$OUTDIR/$SCRIPT.14.log" 2>&1
test_text $SCRIPT.14.log

$(tspath tscmp) $(fpath "$TMPDIR/$SCRIPT.3a.ts") $(fpath "$TMPDIR/$SCRIPT.3b.ts") \
    --search-reorder --json --continue \
    >"$OUTDIR/$SCRIPT.15.log" 2>&1
test_text $SCRIPT.15.log

$(tspath tscmp) $(fpath "$TMPDIR/$SCRIPT.5a.ts") $(fpath "$TMPDIR/$SCRIPT.5b.ts") \
    --search-reorder \
    >"$OUTDIR/$SCRIPT.16.log" 2>&1
test_text $SCRIPT.16.log

$(tspath tscmp) $(fpath "$TMPDIR/$SCRIPT.5a.ts") $(fpath "$TMPDIR/$SCRIPT.5b.ts") \
    --search-reorder --verbose --continue \
    >"$OUTDIR/$SCRIPT.17.log" 2>&1
test_text $SCRIPT.17.log

$(tspath tscmp) $(fpath "$TMPDIR/$SCRIPT.5a.ts") $(fpath "$TMPDIR/$SCRIPT.5b.ts") \
    --search-reorder --json --continue \
    >"$OUTDIR/$SCRIPT.18.log" 2>&1
test_text $SCRIPT.18.log
