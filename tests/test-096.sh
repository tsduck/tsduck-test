#!/usr/bin/env bash
# pidshift plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Clear TS, CBR audio PID's, one is shifted, two are used as reference.
INFILE="$INDIR/test-092.ts"
SHIFTPID=130
REFPID1=131
REFPID2=132

# Shift forward, fixed packet count.
$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P until --packet 40,000 \
    -P continuity --fix \
    -P pes --trace --packet-index --pid $SHIFTPID -o $(fpath "$OUTDIR/$SCRIPT.1.shift.in.txt") \
    -P pes --trace --packet-index --pid $REFPID1 --pid $REFPID2 -o $(fpath "$OUTDIR/$SCRIPT.1.ref.in.txt") \
    -P pidshift --pid $SHIFTPID --packets 10 \
    -P pes --trace --packet-index --pid $SHIFTPID -o $(fpath "$OUTDIR/$SCRIPT.1.shift.out.txt") \
    -P pes --trace --packet-index --pid $REFPID1 --pid $REFPID2 -o $(fpath "$OUTDIR/$SCRIPT.1.ref.out.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.shift.in.txt
test_text $SCRIPT.1.ref.in.txt
test_text $SCRIPT.1.shift.out.txt
test_text $SCRIPT.1.ref.out.txt
test_text $SCRIPT.1.log
test_bin $SCRIPT.1.ts

# Shift backward, fixed packet count.
$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P until --packet 40,000 \
    -P continuity --fix \
    -P pes --trace --packet-index --pid $SHIFTPID -o $(fpath "$OUTDIR/$SCRIPT.2.shift.in.txt") \
    -P pes --trace --packet-index --pid $REFPID1 --pid $REFPID2 -o $(fpath "$OUTDIR/$SCRIPT.2.ref.in.txt") \
    -P pidshift --pid $SHIFTPID --packets 10 --backward \
    -P pes --trace --packet-index --pid $SHIFTPID -o $(fpath "$OUTDIR/$SCRIPT.2.shift.out.txt") \
    -P pes --trace --packet-index --pid $REFPID1 --pid $REFPID2 -o $(fpath "$OUTDIR/$SCRIPT.2.ref.out.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.shift.in.txt
test_text $SCRIPT.2.ref.in.txt
test_text $SCRIPT.2.shift.out.txt
test_text $SCRIPT.2.ref.out.txt
test_text $SCRIPT.2.log
test_bin $SCRIPT.2.ts

# Shift forward, 500 ms.
$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P until --packet 40,000 \
    -P continuity --fix \
    -P pes --trace --packet-index --pid $SHIFTPID -o $(fpath "$OUTDIR/$SCRIPT.3.shift.in.txt") \
    -P pes --trace --packet-index --pid $REFPID1 --pid $REFPID2 -o $(fpath "$OUTDIR/$SCRIPT.3.ref.in.txt") \
    -P pidshift --pid $SHIFTPID --time 500 \
    -P pes --trace --packet-index --pid $SHIFTPID -o $(fpath "$OUTDIR/$SCRIPT.3.shift.out.txt") \
    -P pes --trace --packet-index --pid $REFPID1 --pid $REFPID2 -o $(fpath "$OUTDIR/$SCRIPT.3.ref.out.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.3.ts") \
    >"$OUTDIR/$SCRIPT.3.log" 2>&1

test_text $SCRIPT.3.shift.in.txt
test_text $SCRIPT.3.ref.in.txt
test_text $SCRIPT.3.shift.out.txt
test_text $SCRIPT.3.ref.out.txt
test_text $SCRIPT.3.log
test_bin $SCRIPT.3.ts

# Shift backward, 500 ms.
$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P until --packet 40,000 \
    -P continuity --fix \
    -P pes --trace --packet-index --pid $SHIFTPID -o $(fpath "$OUTDIR/$SCRIPT.4.shift.in.txt") \
    -P pes --trace --packet-index --pid $REFPID1 --pid $REFPID2 -o $(fpath "$OUTDIR/$SCRIPT.4.ref.in.txt") \
    -P pidshift --pid $SHIFTPID --time 500 --backward \
    -P pes --trace --packet-index --pid $SHIFTPID -o $(fpath "$OUTDIR/$SCRIPT.4.shift.out.txt") \
    -P pes --trace --packet-index --pid $REFPID1 --pid $REFPID2 -o $(fpath "$OUTDIR/$SCRIPT.4.ref.out.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.4.ts") \
    >"$OUTDIR/$SCRIPT.4.log" 2>&1

test_text $SCRIPT.4.shift.in.txt
test_text $SCRIPT.4.ref.in.txt
test_text $SCRIPT.4.shift.out.txt
test_text $SCRIPT.4.ref.out.txt
test_text $SCRIPT.4.log
test_bin $SCRIPT.4.ts
