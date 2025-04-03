#!/usr/bin/env bash
# Test various tsp plugins

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"

test_tsp \
    -I file $(fpath "$INFILE") \
    -P history --cas --time -o  $(fpath "$OUTDIR/$SCRIPT.history.txt") \
    -P pcrextract -o  $(fpath "$OUTDIR/$SCRIPT.pcrextract.txt") \
    -P bat --bouquet 0xC001 --increment-version \
    -P tables --pid 17 --tid 74 -o $(fpath "$OUTDIR/$SCRIPT.bat.txt") \
    -P cat --add 0x1234/777/01020304 --remove-casid 0x1811 --increment-version \
    -P tables --pid 1 --tid 1 -o $(fpath "$OUTDIR/$SCRIPT.cat.txt") \
    -P eit -o $(fpath "$OUTDIR/$SCRIPT.eit.txt") \
    -P pat -r 8810 -a 9900/6001 --increment-version \
    -P tables --pid 0 --tid 0 -o $(fpath "$OUTDIR/$SCRIPT.pat.txt") \
    -P pmt --service 8804 -r 442 -r 443 --remove-descriptor 9 --increment-version \
           --add-registration 0x12345678 --add-registration 0x43554549 \
           --add-pid-registration 422/0x43554549 --add-pid-registration 421/0x4B4C5641 \
    -P tables --pid 400 -o $(fpath "$OUTDIR/$SCRIPT.pmt.txt") \
    -P nitscan --comment --dvb-options --variable=FOO_ -o $(fpath "$OUTDIR/$SCRIPT.nitscan.txt") \
    -P nit --increment-version --remove-ts 10 --remove-ts 1003 --remove-ts 1004 \
    -P tables --pid 16 --tid 64 -o $(fpath "$OUTDIR/$SCRIPT.nit.txt") \
    -P sdt --increment-version -s 2000 -n "Foo Channel" -p "Dumb TV" \
    -P tables --pid 17 --tid 66 -o $(fpath "$OUTDIR/$SCRIPT.sdt.txt") \
    -P filter -n -p 0x0BC9 -p 0x019A -p 0x01FE -p 0x0262 -p 0x02C6 -p 0x032A -p 0x038E -p 0x03F2 \
    -P pcrbitrate --min-pcr 32 \
    -P filter -n -p 0x02D2 --stuffing \
    -P inject $(fpath "$INDIR/$SCRIPT.pmt.bin")=100 $(fpath "$INDIR/$SCRIPT.nit.xml")=400 --pid 6000 --bitrate 50,000 \
    -P tables --pid 6000 --all-sections -o $(fpath "$OUTDIR/$SCRIPT.inject.txt") \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.analyze.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.ts") \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_bin $SCRIPT.ts
test_text $SCRIPT.tsp.log
test_text $SCRIPT.history.txt
test_text $SCRIPT.pcrextract.txt
test_text $SCRIPT.bat.txt
test_text $SCRIPT.cat.txt
test_text $SCRIPT.pat.txt
test_text $SCRIPT.pmt.txt
test_text $SCRIPT.nitscan.txt
test_text $SCRIPT.nit.txt
test_text $SCRIPT.sdt.txt
test_text $SCRIPT.eit.txt
test_text $SCRIPT.inject.txt
test_text $SCRIPT.analyze.txt
