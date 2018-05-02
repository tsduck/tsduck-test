#!/bin/bash
# SCTE 35 splice information table injection

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tsp) --synchronous-log --add-input-stuffing 1/5 \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P pmt --pmt-pid 0x03E8 \
           --add-programinfo-id 0x43554549 \
           --add-pid 0x0500/0x86 \
           --set-stream-identifier 0x03F2/1 \
           --set-stream-identifier 0x03FD/2 \
           --set-stream-identifier 0x0413/3 \
    -P spliceinject --service 0x226A --files $(fpath "$INDIR/$SCRIPT.xml") --wait-first-batch \
    -P filter --negate --pid 0x1FFF \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.analyze.txt") \
    -P psi -a -o $(fpath "$OUTDIR/$SCRIPT.psi.txt") \
    -P tables -p 0x0500 -o $(fpath "$OUTDIR/$SCRIPT.sit.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.out.ts") \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_bin $SCRIPT.out.ts
test_text $SCRIPT.analyze.txt
test_text $SCRIPT.psi.txt
test_text $SCRIPT.sit.txt
test_text $SCRIPT.tsp.log
