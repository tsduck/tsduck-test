#!/usr/bin/env bash
# Test various analyses on a 204-byte ISDB-Tb live stream

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
source "$COMMONDIR"/standard-ts-test.sh $SCRIPT.ts
