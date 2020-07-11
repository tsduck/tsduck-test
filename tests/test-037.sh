#!/bin/bash
# Test tables with preferred_section attributes
# Note: the preferred_section is now ignored with EIT's.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
source "$COMMONDIR"/standard-si-test.sh $SCRIPT.xml
