#!/usr/bin/env bash
# Test various analyses on a live stream with HEVC.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
source "$COMMONDIR"/standard-ts-test.sh test-010.ts
