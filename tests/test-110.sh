#!/bin/bash
# Plugin splicemonitor with option --select-commands

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-092.ts"

$(tspath tsp) --synchronous-log --add-input-stuffing 1/2000 \
    -I file $(fpath "$INFILE") \
    -P pmt --pmt-pid 0x006E --add-registration 0x43554549 --add-pid 0x0500/0x86 \
    -P inject $(fpath "$INDIR/$SCRIPT.xml") --pid 0x0500 --inter-packet 2000 --stuffing \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.1.analyze.txt") \
    -P tables --pid 0x0500 --packet-index -o $(fpath "$OUTDIR/$SCRIPT.1.tables.txt") \
    -P splicemonitor --packet-index \
    -O drop \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.analyze.txt
test_text $SCRIPT.1.tables.txt
test_text $SCRIPT.1.log

$(tspath tsp) --synchronous-log --add-input-stuffing 1/2000 \
    -I file $(fpath "$INFILE") \
    -P pmt --pmt-pid 0x006E --add-registration 0x43554549 --add-pid 0x0500/0x86 \
    -P inject $(fpath "$INDIR/$SCRIPT.xml") --pid 0x0500 --inter-packet 2000 --stuffing \
    -P splicemonitor --packet-index --display-commands -o $(fpath "$OUTDIR/$SCRIPT.2.splice.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.splice.txt
test_text $SCRIPT.2.log

$(tspath tsp) --synchronous-log --add-input-stuffing 1/2000 \
    -I file $(fpath "$INFILE") \
    -P pmt --pmt-pid 0x006E --add-registration 0x43554549 --add-pid 0x0500/0x86 \
    -P inject $(fpath "$INDIR/$SCRIPT.xml") --pid 0x0500 --inter-packet 2000 --stuffing \
    -P splicemonitor --packet-index --all-commands -o $(fpath "$OUTDIR/$SCRIPT.3.splice.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.3.log" 2>&1

test_text $SCRIPT.3.splice.txt
test_text $SCRIPT.3.log

$(tspath tsp) --synchronous-log --add-input-stuffing 1/2000 \
    -I file $(fpath "$INFILE") \
    -P pmt --pmt-pid 0x006E --add-registration 0x43554549 --add-pid 0x0500/0x86 \
    -P inject $(fpath "$INDIR/$SCRIPT.xml") --pid 0x0500 --inter-packet 2000 --stuffing \
    -P splicemonitor --packet-index --select-commands 4-6 -o $(fpath "$OUTDIR/$SCRIPT.4.splice.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.4.log" 2>&1

test_text $SCRIPT.4.splice.txt
test_text $SCRIPT.4.log
