#!/usr/bin/env bash
# Test "stats" plugin.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"

test_tsp \
    -I file $(fpath "$INFILE") \
    -P filter --every 10 --set-label 1 \
    -P filter --every 7 --set-label 2 \
    -P stats -o $(fpath "$OUTDIR/$SCRIPT.stats.pids.txt") \
    -P stats -o $(fpath "$OUTDIR/$SCRIPT.stats.labels.txt") --label 1-2 \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

# Weird issue with MSVC library:
# With MSVC, in the following line of $SCRIPT.stats.pids.txt:
#   0x0371          17    6300    6406   6352.62     33.56
# the value "6352.62" is rounded as "6352.63" on Windows GitHub runners,
# even though the MSVC version is the same as other Windows machines
# where the value is "6352.62". We silently abosrb this issue.

if [[ $OS == windows ]]; then
    sed -i -e '/^0x0371/s/6352.63/6352.62/' "$OUTDIR/$SCRIPT.stats.pids.txt"
fi

test_text $SCRIPT.stats.pids.txt
test_text $SCRIPT.stats.labels.txt
test_text $SCRIPT.tsp.log
