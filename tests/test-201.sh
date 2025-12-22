#!/usr/bin/env bash
# Test descriptors: DTMB

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
source "$COMMONDIR"/standard-si-test.sh $SCRIPT.xml --dtmb
