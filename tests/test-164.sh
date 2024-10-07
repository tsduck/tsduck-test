#!/usr/bin/env bash
# Test MPEG-defined descriptors with external blobs

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
source "$COMMONDIR"/standard-si-test.sh $SCRIPT.xml
