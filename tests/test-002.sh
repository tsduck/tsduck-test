#!/usr/bin/env bash
# Test various analyses on an Eutelsat Hot Bird live stream.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
source "$COMMONDIR"/standard-ts-test.sh $SCRIPT.ts --dvb
