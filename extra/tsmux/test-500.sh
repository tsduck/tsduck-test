#!/bin/bash
# Generic muxing test.

cd $(dirname $0)
source ../../common/testrc.sh

# This script is invoked recursively.
case "$1" in
    --play)
        # Play one service from one input file.
        infile=$2
        service=$3
        $(tspath tsp) --max-flushed-packets 16 \
            -I file $(fpath "$INDIR/$infile") \
            -P zap $service --eit \
            -P pcrbitrate \
            -P regulate --packet-burst 16 \
            -P analyze -o $SCRIPT.$service.analysis.txt
        ;;
    "")
        # Main command
        $(tspath tsmux) --bitrate 12,000,000 --max-input-packets 16 --terminate --ts-id 10 --original-network-id 11 \
            -I fork "./$SCRIPT.sh --args '--play $SCRIPT.ts 0x0101'" \
            -I fork "./$SCRIPT.sh --args '--play $SCRIPT.ts 0x0104'" \
            -I fork "./$SCRIPT.sh --args '--play $SCRIPT.ts 0x0106'" \
            -O file $SCRIPT.ts \
            >"./$SCRIPT.log" 2>&1
        ;;
    *)
        error "unknown parameter $1"
        ;;
esac
