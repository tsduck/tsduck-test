#!/bin/bash
# DVB-T bitrates

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

for bw in 8-MHz 7-MHz 6-MHz 5-MHz; do
    for co in QPSK 16-QAM 64-QAM; do
        for gi in 1/32 1/16 1/8 1/4; do
            for fec in 1/2 2/3 3/4 5/6 7/8; do
                echo -n "BW: $bw, constel: $co, guard: $gi, FEC: $fec, bandwidth: "
                $(tspath tsterinfo) -s -w $bw -c $co -g $gi -h $fec
            done
        done
    done
done >"$OUTDIR/$SCRIPT.log" 2>&1

test_text $SCRIPT.log
