#!/usr/bin/env bash
# Test -P nit --build-service-list-descriptors

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"

# Modify an existing NIT.
$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P nit --remove-desc 0x41 --remove-desc 0x4A --remove-desc 0x43 --build-service-list-descriptors \
    -P tables --pid 16 --text $(fpath "$OUTDIR/$SCRIPT.nit.1.txt") \
                       --binary $(fpath "$OUTDIR/$SCRIPT.nit.1.bin") \
                       --xml $(fpath "$OUTDIR/$SCRIPT.nit.1.xml") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1

test_bin $SCRIPT.nit.1.bin
test_text $SCRIPT.nit.1.txt
test_text $SCRIPT.nit.1.xml
test_text $SCRIPT.tsp.1.log

# Create a NIT.
$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --pid 16 --negate --stuffing \
    -P nit --create --build-service-list-descriptors \
    -P tables --pid 16 --text $(fpath "$OUTDIR/$SCRIPT.nit.2.txt") \
                       --binary $(fpath "$OUTDIR/$SCRIPT.nit.2.bin") \
                       --xml $(fpath "$OUTDIR/$SCRIPT.nit.2.xml") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1

test_bin $SCRIPT.nit.2.bin
test_text $SCRIPT.nit.2.txt
test_text $SCRIPT.nit.2.xml
test_text $SCRIPT.tsp.2.log
