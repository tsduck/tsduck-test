#!/usr/bin/env bash
# Plugin nitscan and "tsscan --nit-scan"

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Characteristics of the reference transponders.
declare -A nitmod
nitmod["sat"]="--delivery-system DVB-S --frequency 11,600,000,000 --polarity vertical --symbol 20,000,000 --fec-inner 3/4"
nitmod["cable"]="--delivery-system DVB-C/B --frequency 750,000,000 --modulation 64-QAM --symbol 20,000,000 --fec-inner 3/4"

# Run the tests.
for sys in sat cable; do

    # Display tuner emulator characteristics.
    $(tspath tslsdvb) --verbose --device $(fpath "$INDIR/$SCRIPT.tuner.$sys.xml") \
        >"$OUTDIR/$SCRIPT.tslsdvb.$sys.log" 2>&1

    test_text $SCRIPT.tslsdvb.$sys.log

    # Build the two input streams into the tmp directory.
    (
        $(tspath tspacketize) $(fpath "$INDIR/$SCRIPT.pat.1.xml") --pid 0
        $(tspath tspacketize) $(fpath "$INDIR/$SCRIPT.sdt.1.xml") --pid 17
        $(tspath tspacketize) $(fpath "$INDIR/$SCRIPT.nit.$sys.xml") --pid 16
        $(tspath tspacketize) $(fpath "$INDIR/$SCRIPT.pmt.10.xml") --pid 110
        $(tspath tspacketize) $(fpath "$INDIR/$SCRIPT.pmt.20.xml") --pid 220
    ) >"$TMPDIR/$SCRIPT.$sys.1.ts" 2>"$OUTDIR/$SCRIPT.build.$sys.1.log"
    test_text $SCRIPT.build.$sys.1.log

    $(tspath tstables) $(fpath "$TMPDIR/$SCRIPT.$sys.1.ts") >"$OUTDIR/$SCRIPT.tables.$sys.1.log" 2>&1
    test_text $SCRIPT.tables.$sys.1.log

    (
        $(tspath tspacketize) $(fpath "$INDIR/$SCRIPT.pat.2.xml") --pid 0
        $(tspath tspacketize) $(fpath "$INDIR/$SCRIPT.sdt.2.xml") --pid 17
        $(tspath tspacketize) $(fpath "$INDIR/$SCRIPT.nit.$sys.xml") --pid 16
        $(tspath tspacketize) $(fpath "$INDIR/$SCRIPT.pmt.30.xml") --pid 330
        $(tspath tspacketize) $(fpath "$INDIR/$SCRIPT.pmt.40.xml") --pid 440
    ) >"$TMPDIR/$SCRIPT.$sys.2.ts" 2>"$OUTDIR/$SCRIPT.build.$sys.2.log"
    test_text $SCRIPT.build.$sys.2.log

    $(tspath tstables) $(fpath "$TMPDIR/$SCRIPT.$sys.2.ts") >"$OUTDIR/$SCRIPT.tables.$sys.2.log" 2>&1
    test_text $SCRIPT.tables.$sys.2.log

    # Scan using tsscan.
    $(tspath tsscan) --device $(fpath "$INDIR/$SCRIPT.tuner.$sys.xml") \
        --nit-scan ${nitmod[$sys]} \
        --service-list --global-service-list --show-modulation \
        --save-channels $(fpath "$OUTDIR/$SCRIPT.tsscan.channels.$sys.xml") \
        >"$OUTDIR/$SCRIPT.tsscan.$sys.log" 2>&1

    test_text $SCRIPT.tsscan.$sys.log
    test_text $SCRIPT.tsscan.channels.$sys.xml

    # Scan using plugin nitscan.
    test_tsp \
        -I dvb --device $(fpath "$INDIR/$SCRIPT.tuner.$sys.xml") ${nitmod[$sys]} \
        -P until --packets 10 \
        -P nitscan --dvb-options -o $(fpath "$OUTDIR/$SCRIPT.nitscan.$sys.txt") \
                   --save-channels $(fpath "$OUTDIR/$SCRIPT.nitscan.channels.$sys.xml") \
        -O drop \
        >"$OUTDIR/$SCRIPT.nitscan.$sys.log" 2>&1

    test_text $SCRIPT.nitscan.$sys.log
    test_text $SCRIPT.nitscan.$sys.txt
    test_text $SCRIPT.nitscan.channels.$sys.xml

done
