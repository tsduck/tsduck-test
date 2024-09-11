#!/usr/bin/env bash
# Non-regression on incorrect SCTE 35 program_splice_flag (issue #1519)

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
source "$COMMONDIR"/standard-si-test.sh $SCRIPT.xml
