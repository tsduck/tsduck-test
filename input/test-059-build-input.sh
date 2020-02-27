#!/bin/bash
# A script to build the input TS of this test.
# Executed once and archived for reference.

PREFIX=test-059

cd $(dirname $0)

tsp -v \
    -I http https://tsduck.io/streams/france-dttv/tnt-uhf30-546MHz-2019-01-22.ts \
    -P svremove m6 \
    -P svremove w9 \
    -P svremove 6ter \
    -P file $PREFIX.2a.ts \
    -P zap arte --stuffing \
    -P pmt --pmt-pid 0x012C --increment-version \
    -P sdt --increment-version \
    -P pat --increment-version \
    -O file $PREFIX.1a.ts

tstables $PREFIX.1a.ts --max 1 --pid 0x11 --tid 0x42 --bin $PREFIX.sdt.1.bin
tstables $PREFIX.2a.ts --max 1 --pid 0x11 --tid 0x42 --bin $PREFIX.sdt.2.bin

tsp -I file $PREFIX.1a.ts \
    -P filter --negate --pid 0x11 --stuffing \
    -P inject $PREFIX.sdt.1.bin --pid 0x11 --stuffing --inter-packet 500 \
    -O file $PREFIX.1.ts

tsp -I file $PREFIX.2a.ts \
    -P filter --negate --pid 0x11 --stuffing \
    -P inject $PREFIX.sdt.2.bin --pid 0x11 --stuffing --inter-packet 500 \
    -O file $PREFIX.2.ts

p1=5312
p2=14792
p3=24223
p4=34047
p5=43986

tsp -I file $PREFIX.1.ts -P skip $p1 -P until -p $(($p2-$p1)) -O file $PREFIX.x.ts
tsp -I file $PREFIX.2.ts -P skip $p2 -P until -p $(($p3-$p2)) -O file $PREFIX.x.ts --append
tsp -I file $PREFIX.1.ts -P skip $p3 -P until -p $(($p4-$p3)) -O file $PREFIX.x.ts --append
tsp -I file $PREFIX.2.ts -P skip $p4 -P until -p $(($p5-$p4)) -O file $PREFIX.x.ts --append
tsp -I file $PREFIX.x.ts -P filter -n -p 0x1FFF -O file $PREFIX.ts

rm -f $PREFIX.*.ts $PREFIX.sdt.*.bin
