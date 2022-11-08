#!/usr/bin/env bash
# Test various analyses on an Eutelsat Hot Bird live stream with MPE data broadcast.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
source "$COMMONDIR"/standard-ts-test.sh $SCRIPT.ts
