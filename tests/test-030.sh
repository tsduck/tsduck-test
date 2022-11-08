#!/usr/bin/env bash
# Sections plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INDIR/$SCRIPT.ts") \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.analyze.in.txt") \
    -P sections -p 0x00 -p 0x12 -p 0x112 -o 0x444 --tid 0x4F \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.analyze.out.txt") \
    -P tables -a -o $(fpath "$OUTDIR/$SCRIPT.tables.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.out.ts") \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_bin $SCRIPT.out.ts
test_text $SCRIPT.analyze.in.txt
test_text $SCRIPT.analyze.out.txt
test_text $SCRIPT.tables.txt
test_text $SCRIPT.tsp.log

# Test various combinations of options.

OPTIONS=(
    ""
    "--tid 2"
    "--tid-ext 0x2269 --version 7"
    "--tid-ext 0x2269 --version 7 --and"
    "--etid 0x022260-0x022266"
    "--tid 2 --keep"
    "--tid-ext 0x2269 --version 7 --keep"
    "--tid-ext 0x2269 --version 7 --and --keep"
)
PIDS="0x0000 0x0001 0x0064 0x00C8 0x012C 0x0190 0x01F4 0x0258 0x02BC 0x0320 0x0384 0x03E8 0x1003"
PIDSOPT="--pid ${PIDS// / --pid }"

for ((i=0; $i<${#OPTIONS[@]}; i++)); do

    $(tspath tsp) --synchronous-log \
        -I file $(fpath "$INDIR/test-001.ts") \
        -P sections ${OPTIONS[$i]} $PIDSOPT --output-pid 0x1F00 \
        -P tables --pid 0x1F00 --log --text $(fpath "$OUTDIR/$SCRIPT.$i.txt") \
        -O drop \
        >"$OUTDIR/$SCRIPT.$i.log" 2>&1

    test_text $SCRIPT.$i.txt
    test_text $SCRIPT.$i.log

done
