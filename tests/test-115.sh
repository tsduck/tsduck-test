#!/bin/bash
# Test VVC, EVC, LCEVC, AVS3 descriptors

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
source "$COMMONDIR"/standard-si-test.sh $SCRIPT.xml --avs
