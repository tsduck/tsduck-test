#!/usr/bin/env bash
# Test DSM-CC UNM and specific descriptors

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
source "$COMMONDIR"/standard-si-test.sh $SCRIPT.xml --dvb
