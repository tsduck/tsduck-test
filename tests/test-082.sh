#!/usr/bin/env bash
# Automated XML-to-JSON conversions.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# List of test options:
OPTS=(
    "--tables --json"
    "--tables --json --x2j-include-root"
    "--tables --json-line=JSON:"
    "--json"
    "--json --x2j-collapse-text"
    "--json --x2j-enforce-integer --x2j-enforce-boolean"
)

for ((i=0; $i<${#OPTS[@]}; i++)); do

    $(tspath tsxml) ${OPTS[$i]} \
        $(fpath "$INDIR/$SCRIPT.xml") \
        --output $(fpath "$OUTDIR/$SCRIPT.$i.json") \
        >"$OUTDIR/$SCRIPT.$i.log" 2>&1

    [[ ${OPTS[$i]} == *json-line* ]] || test_text $SCRIPT.$i.json
    test_text $SCRIPT.$i.log

done
