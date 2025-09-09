#!/usr/bin/env bash
# YAML output of tsxml

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

for n in 1 2 3; do

    $(tspath tsxml) --tables $(fpath "$INDIR/$SCRIPT.$n.xml") \
        --yaml --output $(fpath "$OUTDIR/$SCRIPT.$n.yml") \
        >"$OUTDIR/$SCRIPT.$n.log" 2>&1

    test_text $SCRIPT.$n.yml
    test_text $SCRIPT.$n.log

done
