#!/usr/bin/env bash
# Test DSM-CC UNM and specific descriptors.
#  - test-179.1.xml: DSI with object-carousel IOR (BIOP ServiceGateway)
#  - test-179.2.xml: DSI with data-carousel GroupInfoIndication

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

ORIG_SCRIPT=$SCRIPT
for n in 1 2; do
    SCRIPT="$ORIG_SCRIPT.$n"
    source "$COMMONDIR"/standard-si-test.sh $SCRIPT.xml --dvb
done
SCRIPT=$ORIG_SCRIPT
