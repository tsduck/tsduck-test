#!/usr/bin/env bash
# zap plugin with multiple services

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P zap canal+cinema cnews \
    -P pcrbitrate --min-pcr 4 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.1.txt") \
    -P psi -a -o $(fpath "$OUTDIR/$SCRIPT.1.psi.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1

test_text $SCRIPT.1.txt
test_text $SCRIPT.1.psi.txt
test_text $SCRIPT.1.log
test_bin $SCRIPT.1.ts

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P zap 0x2263 cnews --eit --no-ecm --audio eng \
    -P pcrbitrate --min-pcr 4 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.2.txt") \
    -P psi -a -o $(fpath "$OUTDIR/$SCRIPT.2.psi.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1

test_text $SCRIPT.2.txt
test_text $SCRIPT.2.psi.txt
test_text $SCRIPT.2.log
test_bin $SCRIPT.2.ts

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P zap 0x2263 0x226A --no-subtitles \
    -P pcrbitrate --min-pcr 4 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.3.txt") \
    -P psi -a -o $(fpath "$OUTDIR/$SCRIPT.3.psi.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.3.ts") \
    >"$OUTDIR/$SCRIPT.3.log" 2>&1

test_text $SCRIPT.3.txt
test_text $SCRIPT.3.psi.txt
test_text $SCRIPT.3.log
test_bin $SCRIPT.3.ts
