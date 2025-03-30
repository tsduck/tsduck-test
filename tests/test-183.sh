#!/usr/bin/env bash
# SI analysis and conversions: additional ATSC descriptors

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
source "$COMMONDIR"/standard-si-test.sh $SCRIPT.xml --atsc
