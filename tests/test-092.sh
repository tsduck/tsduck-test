#!/usr/bin/env bash
# Test various analyses on an Astra live stream.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
source "$COMMONDIR"/standard-ts-test.sh test-092.ts
