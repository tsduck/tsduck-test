#!/usr/bin/env bash
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
# - Restore original PAT, SDT/BAT, EIT.
# - Remove PID 0x1000 from service 0x2262.
# - Take a binary and analysis snapshot.

test-encap()
{
    local encapopt="$1"
    local suffix="$2"

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
        -P pcrbitrate --min-pcr 4 \
        -P analyze -o $(fpath "$OUTDIR/$SCRIPT.in${suffix}.txt") \
        -P duplicate 0x00=0x1001 0x11=0x1002 \
        -P encap $encapopt --output-pid 0x1000 --pcr-pid 0x00D2 \
            -p 0x0012 -p 0x03E8 -p 0x03F2 -p 0x03FD -p 0x0413 -p 0x1001 -p 0x1002 \
        -P pat --increment --remove-service 0x226A \
        -P sdt --increment --remove-service 0x226A \
        -P pmt --increment -s 0x2262 -a 0x1000/0x99 \
        -P filter -n -p 0x0012 -p 0x1FFF \
        -P pcrbitrate --min-pcr 4 \
        -P analyze -o $(fpath "$OUTDIR/$SCRIPT.encap${suffix}.txt") \
        -P file $(fpath "$OUTDIR/$SCRIPT.encap${suffix}.ts") \
        -P decap -p 0x1000 \
        -P filter -n -p 0x00 -p 0x11 \
        -P remap --unchecked --no-psi 0x1001=0x00 0x1002=0x11 \
        -P pmt --increment -s 0x2262 -r 0x1000 \
        -P analyze -o $(fpath "$OUTDIR/$SCRIPT.decap${suffix}.txt") \
        -O file $(fpath "$OUTDIR/$SCRIPT.decap${suffix}.ts") \
        >"$OUTDIR/$SCRIPT${suffix}.log" 2>&1

    test_bin $SCRIPT.encap${suffix}.ts
    test_bin $SCRIPT.decap${suffix}.ts
    test_text $SCRIPT.encap${suffix}.txt
    test_text $SCRIPT.decap${suffix}.txt
    test_text $SCRIPT${suffix}.log

    # Extract the 4 PID's in temporary directory (not saved in repository).

    $(tspath tsp) --synchronous-log \
        -I file $(fpath "$INFILE") \
        -P filter -p 0x03E8 -p 0x03F2 -p 0x03FD -p 0x0413 \
        -O file $(fpath "$TMPDIR/$SCRIPT.srv.orig${suffix}.ts") \
        >"$OUTDIR/$SCRIPT.srv.orig.log" 2>&1

    $(tspath tsp) --synchronous-log \
        -I file $(fpath "$OUTDIR/$SCRIPT.decap${suffix}.ts") \
        -P filter -p 0x03E8 -p 0x03F2 -p 0x03FD -p 0x0413 \
        -O file $(fpath "$TMPDIR/$SCRIPT.srv.decap${suffix}.ts") \
        >"$OUTDIR/$SCRIPT.srv.decap${suffix}.log" 2>&1

    test_text $SCRIPT.srv.orig.log
    test_text $SCRIPT.srv.decap${suffix}.log

    $(tspath tscmp) --continue --search-reorder \
        $(fpath "$TMPDIR/$SCRIPT.srv.orig${suffix}.ts") \
        $(fpath "$TMPDIR/$SCRIPT.srv.decap${suffix}.ts") \
        >"$OUTDIR/$SCRIPT.cmp${suffix}.log" 2>&1

    test_text $SCRIPT.cmp${suffix}.log
}

test-encap
test-encap --pack .pack
test-encap "--pes-mode 1" .pes1
test-encap "--pes-mode 2" .pes2
