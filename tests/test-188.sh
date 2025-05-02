#!/usr/bin/env bash
# Test SES Astra specific table and descriptors

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
source "$COMMONDIR"/standard-si-test.sh $SCRIPT.xml --dvb
