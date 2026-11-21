#!/usr/bin/env bash
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
    name=$(basename $script .sh)
    trace "Running $name.sh"
    t0=$(start_time)
    $script "${args[@]}"
    sec=$(duration_since $t0)
    trace "$name: $sec"
done
test_exit
