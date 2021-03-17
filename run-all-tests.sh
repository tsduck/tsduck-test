#!/bin/bash
# -----------------------------------------------------------
# Run all TSDuck tests
# -----------------------------------------------------------

args=("$@")
source $(dirname $0)/common/testrc.sh
tmp=$(which "$(tspath tsp)")
tsbindir=$(dirname "$tmp")
$(tspath tsp) --version 2>&1 | sed -e "s|^tsp:|$PRPASS  Testing|" -e "s|\$| from $tsbindir|"
test_start
for script in "$TESTSDIR"/test*.sh; do
    trace "Running $(basename $script)"
    $script "${args[@]}"
done
test_exit
