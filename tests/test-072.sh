#!/usr/bin/env bash
# Non-regression on pes plugin (issue #646)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

source "$COMMONDIR"/standard-ts-test.sh $SCRIPT.ts

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P pes --packet-index --header \
    -O drop \
    >"$OUTDIR/$SCRIPT.pes.log" 2>&1

test_text $SCRIPT.pes.log
