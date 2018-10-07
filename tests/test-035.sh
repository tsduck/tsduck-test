#!/bin/bash
# Test encap and decap plugins

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-001.ts"

# - Remove all services but two, remove all EMM PID's.
# - Take an analysis snapshot.
# - Encapsulate all PID's of service 0x226A in PID 0x1000.
# - Remove references to this service from PAT and SDT.
# - Make PID 0x1000 a private component of service 0x2262.
# => Service 0x226A has disappeared into a private component of service 0x2262.
# - Take a binary and analysis snapshot.
# - Decapsulate PID 0x1000.
# - Restore reference to service 0x226A in PAT and SDT.
# - Remove PID 0x1000 from service 0x2262.
# - Take a binary and analysis snapshot.

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P svremove 0x2261 --stuffing \
    -P svremove 0x2263 \
    -P svremove 0x2264 \
    -P svremove 0x2265 \
    -P svremove 0x2266 \
    -P svremove 0x2267 \
    -P svremove 0x2268 \
    -P svremove 0x2269 \
    -P svremove 0x22C3 \
    -P filter -n -p 0x0001 -p 0x1449 -p 0x1645 -p 0x1646 -p 0x1647 -p 0x164E -p 0x1650 \
                 -p 0x165D -p 0x168A -p 0x168C -p 0x168F -p 0x1690 -p 0x1699 -p 0x0BC9 \
    -P pcrbitrate \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.in.txt") \
    -P encap --output-pid 0x1000 --pcr-pid 0x00D2 -p 0x03E8 -p 0x03F2 -p 0x03FD -p 0x0413 \
    -P pat --remove-service 0x226A \
    -P sdt --remove-service 0x226A \
    -P pmt -s 0x2262 -a 0x1000/0x99 \
    -P filter -n -p 0x1FFF \
    -P pcrbitrate \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.encap.txt") \
    -P file $(fpath "$OUTDIR/$SCRIPT.encap.ts") \
    -P decap -p 0x1000 \
    -P pat -a 0x226A/0x03E8 \
    -P sdt -s 0x226A -n CNEWS -p CSAT \
    -P pmt -s 0x2262 -r 0x1000 \
    -P analyze -o $(fpath "$OUTDIR/$SCRIPT.decap.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.decap.ts") \
    >"$OUTDIR/$SCRIPT.log" 2>&1

test_bin $SCRIPT.encap.ts
test_bin $SCRIPT.decap.ts
test_text $SCRIPT.encap.txt
test_text $SCRIPT.decap.txt
test_text $SCRIPT.log

# Extract the 4 PID's in temporary directory (not saved in repository).

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$INFILE") \
    -P filter -p 0x03E8 -p 0x03F2 -p 0x03FD -p 0x0413 \
    -O file $(fpath "$TMPDIR/$SCRIPT.srv.orig.ts") \
    >"$OUTDIR/$SCRIPT.srv.orig.log" 2>&1

$(tspath tsp) --synchronous-log \
    -I file $(fpath "$OUTDIR/$SCRIPT.decap.ts") \
    -P filter -p 0x03E8 -p 0x03F2 -p 0x03FD -p 0x0413 \
    -O file $(fpath "$TMPDIR/$SCRIPT.srv.decap.ts") \
    >"$OUTDIR/$SCRIPT.srv.decap.log" 2>&1

test_text $SCRIPT.srv.orig.log
test_text $SCRIPT.srv.decap.log

cd "$TMPDIR"
$(tspath tscmp) --continue --subset "$SCRIPT.srv.orig.ts" "$SCRIPT.srv.decap.ts" \
    >"$OUTDIR/$SCRIPT.cmp.log" 2>&1

test_text $SCRIPT.cmp.log
