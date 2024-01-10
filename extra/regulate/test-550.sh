#!/usr/bin/env bash
# Regulate a TS and periodically evaluate it.

tsp --verbose --bitrate 10,000,000 \
    -I null \
    -P regulate \
    -P bitrate_monitor --periodic-bitrate 5 \
    -O drop
