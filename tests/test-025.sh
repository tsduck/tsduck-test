#!/usr/bin/env bash
# Non-regression test on a stream which crashed tsanalyzer (issue #49).

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
source "$COMMONDIR"/standard-ts-test.sh $SCRIPT.ts
