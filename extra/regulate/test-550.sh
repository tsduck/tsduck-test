#!/usr/bin/env bash
# Regulate a TS and periodically evaluate it.

source $(dirname $0)/../../common/testrc.sh

test_tsp --verbose --bitrate 10,000,000 \
    -I null \
    -P regulate \
    -P bitrate_monitor --periodic-bitrate 5 \
    -O drop
