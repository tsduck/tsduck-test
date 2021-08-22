#!/bin/bash
# tspcap

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

$(tspath tspcap) $(fpath "$INDIR/$SCRIPT.pcapng") >"$OUTDIR/$SCRIPT.1.log" 2>&1
test_text $SCRIPT.1.log

$(tspath tspcap) $(fpath "$INDIR/$SCRIPT.pcapng") --list-streams >"$OUTDIR/$SCRIPT.2.log" 2>&1
test_text $SCRIPT.2.log

$(tspath tspcap) $(fpath "$INDIR/$SCRIPT.pcapng") --interval 200,000 >"$OUTDIR/$SCRIPT.3.log" 2>&1
test_text $SCRIPT.3.log
