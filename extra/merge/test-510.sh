#!/usr/bin/env bash
# Test merge plugin and restart option.
#
# The main stream contains services "France 2" and "France 4", and a lot of stuffing.
# The merged stream contains service "France O".
# Every 10 seconds, the list of service is displayed.
# The test is correct if all three services are displayed.
# Use "ps fax" to display the list of processes.
# Locate the merged process and kill it.
# It should restart.

cd $(dirname $0)
source ../../common/testrc.sh

INFILE="$INDIR/test-092.ts"

$(tspath tsp) \
    -I file -i $(fpath "$INFILE") \
    -P regulate \
    -P svremove -s 0x0105 \
    -P svremove -s 0x0106 \
    -P svremove -s 0x0111 \
    -P svremove -s 0x0170 \
    -P merge --restart --no-smoothing "$(fpath $(tspath tsp)) -I file -i "$(fpath "$INFILE")" -P regulate -P zap 0x0105" \
    -P analyze --ts --interval 10 \
    -O drop
