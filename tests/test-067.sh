#!/usr/bin/env bash
# Test DTG (UK DTT) private descriptors

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
source "$COMMONDIR"/standard-si-test.sh $SCRIPT.xml
