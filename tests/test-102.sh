#!/bin/bash
# tspcap

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tspcap) \
    $(fpath "$INDIR/$SCRIPT.pcapng") >"$OUTDIR/$SCRIPT.1.log" 2>&1
test_text $SCRIPT.1.log

$(tspath tspcap) --list-streams \
    $(fpath "$INDIR/$SCRIPT.pcapng") >"$OUTDIR/$SCRIPT.2.log" 2>&1
test_text $SCRIPT.2.log

$(tspath tspcap) --interval 200,000 \
    $(fpath "$INDIR/$SCRIPT.pcapng") >"$OUTDIR/$SCRIPT.3.log" 2>&1
test_text $SCRIPT.3.log

$(tspath tspcap) --first-packet 100 --last-packet 200 \
    $(fpath "$INDIR/$SCRIPT.pcapng") >"$OUTDIR/$SCRIPT.4.log" 2>&1
test_text $SCRIPT.4.log

$(tspath tspcap) --first-date 2021/08/14:15:39:45.0 --last-date 2021/08/14:15:39:46.0 \
    $(fpath "$INDIR/$SCRIPT.pcapng") >"$OUTDIR/$SCRIPT.5.log" 2>&1
test_text $SCRIPT.5.log

$(tspath tspcap) --first-timestamp 500,000 --last-timestamp 1,500,000 \
    $(fpath "$INDIR/$SCRIPT.pcapng") >"$OUTDIR/$SCRIPT.6.log" 2>&1
test_text $SCRIPT.6.log
