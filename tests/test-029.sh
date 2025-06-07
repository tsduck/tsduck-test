#!/usr/bin/env bash
# DVB-T information

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Compute DVB-T bitrates

for bw in 8-MHz 7-MHz 6-MHz 5-MHz; do
    for co in QPSK 16-QAM 64-QAM; do
        for gi in 1/32 1/16 1/8 1/4; do
            for fec in 1/2 2/3 3/4 5/6 7/8; do
                echo -n "BW: $bw, constel: $co, guard: $gi, FEC: $fec, bitrate: "
                $(tspath tsterinfo) -s -w $bw -c $co -g $gi -h $fec
            done
        done
    done
done >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.log

# Guess DVB-T modulation parameters from bitrate

while read bitrate; do
    echo
    echo "==== Bitrate: $bitrate"
    echo
    $(tspath tsterinfo) --bitrate $bitrate
done <"$INDIR/$SCRIPT.bitrates.txt" >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.log

# Compute UHF frequencies

for ((uhf=21; $uhf<69; uhf++)); do
    for ((off=-1; $off<3; off++)); do
        printf 'UHF %d offset %d: %d Hz\n' $uhf $off $($(tspath tsterinfo) -s -r europe -u $uhf -o $off)
    done
done >"$OUTDIR/$SCRIPT.3.log" 2>&1

test_text $SCRIPT.3.log
