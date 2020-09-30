#!/bin/bash
# ------------------------------------------------------------------------------
# Perform the "standard" set of tests on a transport stream file.
# Syntax: source "$COMMONDIR"/standard-ts-test.sh input.ts [--atsc|--isdb]
# ------------------------------------------------------------------------------

INFILE="$INDIR/$1"
STDOPT=$2

# ==== tsanalyze, as a command

$(tspath tsanalyze) $(fpath "$INFILE") --title "$SCRIPT tsanalyze full" $STDOPT \
    >"$OUTDIR/$SCRIPT.tsanalyze.full.txt" \
    2>"$OUTDIR/$SCRIPT.tsanalyze.full.log"

test_text $SCRIPT.tsanalyze.full.txt
test_text $SCRIPT.tsanalyze.full.log

# ==== tsanalyze, as a command, wide display

$(tspath tsanalyze) $(fpath "$INFILE") --title "$SCRIPT tsanalyze wide" --wide-display $STDOPT \
    >"$OUTDIR/$SCRIPT.tsanalyze.wide.txt" \
    2>"$OUTDIR/$SCRIPT.tsanalyze.wide.log"

test_text $SCRIPT.tsanalyze.wide.txt
test_text $SCRIPT.tsanalyze.wide.log

# ==== tsanalyze, as a command, normalized format

$(tspath tsanalyze) $(fpath "$INFILE") --title "$SCRIPT tsanalyze norm" --normalized $STDOPT \
    >"$OUTDIR/$SCRIPT.tsanalyze.norm.txt" \
    2>"$OUTDIR/$SCRIPT.tsanalyze.norm.log"

# remove current system time info from output, non reproduceable
sed -i -e'/^time:.*:system:/d' "$OUTDIR/$SCRIPT.tsanalyze.norm.txt"
test_text $SCRIPT.tsanalyze.norm.txt
test_text $SCRIPT.tsanalyze.norm.log

# ==== tspsi, as a command

$(tspath tspsi) $(fpath "$INFILE") $STDOPT \
    >"$OUTDIR/$SCRIPT.tspsi.txt" \
    2>"$OUTDIR/$SCRIPT.tspsi.log"

test_text $SCRIPT.tspsi.txt
test_text $SCRIPT.tspsi.log

# ==== analyze and psi, as plugins

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.tsp.analyze.full.txt") --title "$SCRIPT full" $STDOPT \
    -P analyze --normalized -o $(fpath "$OUTDIR/$SCRIPT.tsp.analyze.norm.txt") --title "$SCRIPT normalized" $STDOPT \
    -P analyze --json -o $(fpath "$OUTDIR/$SCRIPT.tsp.analyze.json") --title "$SCRIPT JSON" $STDOPT \
    -P psi --all -o $(fpath "$OUTDIR/$SCRIPT.tsp.psi.txt") $STDOPT \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

sed -i -e '/^time:.*:system:/d' "$OUTDIR/$SCRIPT.tsp.analyze.norm.txt"
test_text $SCRIPT.tsp.analyze.full.txt
test_text $SCRIPT.tsp.analyze.norm.txt
test_text $SCRIPT.tsp.analyze.json
test_text $SCRIPT.tsp.psi.txt
test_text $SCRIPT.tsp.log

# ==== tsbitrate using PCR

$(tspath tsbitrate) $(fpath "$INFILE") --full --all \
    >"$OUTDIR/$SCRIPT.tsbitrate.pcr.txt" \
    2>"$OUTDIR/$SCRIPT.tsbitrate.pcr.log"

test_text $SCRIPT.tsbitrate.pcr.txt
test_text $SCRIPT.tsbitrate.pcr.log

# ==== tsbitrate using DTS

$(tspath tsbitrate) $(fpath "$INFILE") --full --all --dts \
    >"$OUTDIR/$SCRIPT.tsbitrate.dts.txt" \
    2>"$OUTDIR/$SCRIPT.tsbitrate.dts.log"

test_text $SCRIPT.tsbitrate.dts.txt
test_text $SCRIPT.tsbitrate.dts.log

# ==== tsdate

$(tspath tsdate) $(fpath "$INFILE") --all \
    >"$OUTDIR/$SCRIPT.tsdate.txt" \
    2>"$OUTDIR/$SCRIPT.tsdate.log"

# In the input database, we have one test with a corrupted TDT:
# - Received:   70 70 05 *82* 84 11 03 35 => 1950/05/11 11:03:35.000
# - Instead of: 70 70 05 *E2* 84 11 03 35 => 2017/08/23 11:03:35.000
# The problem is that 1950 is not a valid UNIX time. So, depending on the platform,
# the date is displayed either as 1950 or 1970/01/01 (UNIX epoch, invalid time).
# Remove them all.
sed -i -e '/1950\/05\/11/d' -e '/1970\/01\/01/d' "$OUTDIR/$SCRIPT.tsdate.txt"

test_text $SCRIPT.tsdate.txt
test_text $SCRIPT.tsdate.log

# ==== tsdump, first 10 packets.

($(tspath tsp) --synchronous-log -I file $(fpath "$INFILE") -P until --packet 10 | $(tspath tsdump)) \
    >"$OUTDIR/$SCRIPT.tsdump.txt" \
    2>"$OUTDIR/$SCRIPT.tsdump.log"

test_text $SCRIPT.tsdump.txt
test_text $SCRIPT.tsdump.log

($(tspath tsp) --synchronous-log -I file $(fpath "$INFILE") -P until --packet 10 | $(tspath tsdump) --header) \
    >"$OUTDIR/$SCRIPT.tsdump.header.txt" \
    2>"$OUTDIR/$SCRIPT.tsdump.header.log"

test_text $SCRIPT.tsdump.header.txt
test_text $SCRIPT.tsdump.header.log

# ==== tstables, save all psi/si, search for PMT's

PMTPIDS=$(grep '^table:.*tid=2:' $OUTDIR/$SCRIPT.tsanalyze.norm.txt | sed -e 's/^.*:pid=/-p /' -e 's/:.*$//' | tr '\n' ' ')
PIDS="-p 0 -p 1 -p 2 -p 16 -p 17 -p 18 -p 19 -p 0x1FFB $PMTPIDS"

$(tspath tstables) $(fpath "$INFILE") $PIDS $STDOPT \
    --output-file $(fpath "$OUTDIR/$SCRIPT.tstables.text.txt") \
    >"$OUTDIR/$SCRIPT.tstables.text.log" 2>&1

test_text $SCRIPT.tstables.text.txt
test_text $SCRIPT.tstables.text.log

# ==== tstables, XML files

$(tspath tstables) $(fpath "$INFILE") $PIDS --packet-index $STDOPT \
    --xml $(fpath "$OUTDIR/$SCRIPT.tstables.xml") \
    >"$OUTDIR/$SCRIPT.tstables.xml.log" 2>&1

test_text $SCRIPT.tstables.xml
test_text $SCRIPT.tstables.xml.log

$(tspath tstables) $(fpath "$INFILE") $PIDS --packet-index $STDOPT \
    --strict-xml --xml $(fpath "$OUTDIR/$SCRIPT.tstables.strict.xml") \
    >"$OUTDIR/$SCRIPT.tstables.strict.xml.log" 2>&1

test_text $SCRIPT.tstables.strict.xml
test_text $SCRIPT.tstables.strict.xml.log

# ==== tstables, binary sections

$(tspath tstables) $(fpath "$INFILE") $PIDS $STDOPT \
    --binary $(fpath "$OUTDIR/$SCRIPT.tstables.bin") \
    >"$OUTDIR/$SCRIPT.tstables.bin.log" 2>&1

test_bin $SCRIPT.tstables.bin
test_text $SCRIPT.tstables.bin.log

# ==== tstabdump

$(tspath tstabdump) $(fpath "$OUTDIR/$SCRIPT.tstables.bin") $STDOPT \
    >"$OUTDIR/$SCRIPT.tstabdump.txt" \
    2>"$OUTDIR/$SCRIPT.tstabdump.log"

test_text $SCRIPT.tstabdump.txt
test_text $SCRIPT.tstabdump.log
