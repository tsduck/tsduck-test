#!/usr/bin/env bash
# Test filter plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --pattern 4A6C --search-payload \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1

test_bin $SCRIPT.1.ts
test_text $SCRIPT.tsp.1.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --pattern 4A6CF2 \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1

test_bin $SCRIPT.2.ts
test_text $SCRIPT.tsp.2.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --pattern 4A6CF200 \
    -O file $(fpath "$OUTDIR/$SCRIPT.3.ts") \
    >"$OUTDIR/$SCRIPT.tsp.3.log" 2>&1

test_bin $SCRIPT.3.ts
test_text $SCRIPT.tsp.3.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --pattern 4A6CF2 --search-offset 0xB8 \
    -O file $(fpath "$OUTDIR/$SCRIPT.4.ts") \
    >"$OUTDIR/$SCRIPT.tsp.4.log" 2>&1

test_bin $SCRIPT.4.ts
test_text $SCRIPT.tsp.4.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --pattern 4A6CF2 --search-payload --search-offset 0xB4 \
    -O file $(fpath "$OUTDIR/$SCRIPT.5.ts") \
    >"$OUTDIR/$SCRIPT.tsp.5.log" 2>&1

test_bin $SCRIPT.5.ts
test_text $SCRIPT.tsp.5.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --pattern 4A6C --search-payload --search-offset 0xB4 \
    -O file $(fpath "$OUTDIR/$SCRIPT.6.ts") \
    >"$OUTDIR/$SCRIPT.tsp.6.log" 2>&1

test_bin $SCRIPT.6.ts
test_text $SCRIPT.tsp.6.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --ecm \
    -P count -o $(fpath "$OUTDIR/$SCRIPT.7.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.7.log" 2>&1

test_text $SCRIPT.7.txt
test_text $SCRIPT.tsp.7.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --emm \
    -P count -o $(fpath "$OUTDIR/$SCRIPT.8.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.8.log" 2>&1

test_text $SCRIPT.8.txt
test_text $SCRIPT.tsp.8.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --audio \
    -P count -o $(fpath "$OUTDIR/$SCRIPT.9.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.9.log" 2>&1

test_text $SCRIPT.9.txt
test_text $SCRIPT.tsp.9.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --video \
    -P count -o $(fpath "$OUTDIR/$SCRIPT.10.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.10.log" 2>&1

test_text $SCRIPT.10.txt
test_text $SCRIPT.tsp.10.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --subtitles \
    -P count -o $(fpath "$OUTDIR/$SCRIPT.11.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.11.log" 2>&1

test_text $SCRIPT.11.txt
test_text $SCRIPT.tsp.11.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --psi-si \
    -P count -o $(fpath "$OUTDIR/$SCRIPT.12.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.12.log" 2>&1

test_text $SCRIPT.12.txt
test_text $SCRIPT.tsp.12.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --codec avc \
    -P count -o $(fpath "$OUTDIR/$SCRIPT.13.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.13.log" 2>&1

test_text $SCRIPT.13.txt
test_text $SCRIPT.tsp.13.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter --service canal+ --service 0x2262 \
    -P count -o $(fpath "$OUTDIR/$SCRIPT.14.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.14.log" 2>&1

test_text $SCRIPT.14.txt
test_text $SCRIPT.tsp.14.log

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INDIR/test-092.ts") \
    -P filter --intra-frame \
    -P count -o $(fpath "$OUTDIR/$SCRIPT.15.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.15.log" 2>&1

test_text $SCRIPT.15.txt
test_text $SCRIPT.tsp.15.log
