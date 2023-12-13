#!/usr/bin/env bash
# Test a stream with HDMV registration and DTS-HD Master Audio

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
source "$COMMONDIR"/standard-ts-test.sh $SCRIPT.ts
