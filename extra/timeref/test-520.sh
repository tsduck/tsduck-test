#!/bin/bash
# Test timeref plugin with --system-synchronous

cd $(dirname $0)
source ../../common/testrc.sh

$(tspath tsp) -v --bitrate 1,000,000 \
    -I null \
    -P regulate \
    -P inject tdt.xml=5000 tot.xml=15000 --pid 20 \
    -P timeref --system-synchronous --local-time-offset -120 --next-change 2021/10/20:02:00:00 --next-time-offset -180 \
    -P tables -a -p 20 \
    -O drop
