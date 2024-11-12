#!/usr/bin/env bash
# Test packet trailers in a 204-byte ISDB-Tb live stream

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

INFILE="$INDIR/test-170.ts"

# 1) Input "file" 204-byte (original) -> output "file" 204-byte
test_tsp \
    -I file $(fpath "$INFILE") \
    -P until --packets 200 \
    -O file $(fpath "$OUTDIR/$SCRIPT.1.ts") --format rs204 \
    >"$OUTDIR/$SCRIPT.tsp.1.log" 2>&1

test_text $SCRIPT.tsp.1.log
test_bin $SCRIPT.1.ts

# 2) Input "file" 204-byte (original) -> output "file" 188-byte
test_tsp \
    -I file $(fpath "$INFILE") \
    -P until --packets 200 \
    -O file $(fpath "$OUTDIR/$SCRIPT.2.ts") --format ts \
    >"$OUTDIR/$SCRIPT.tsp.2.log" 2>&1

test_text $SCRIPT.tsp.2.log
test_bin $SCRIPT.2.ts

# 3) Input "tsdump" 204-byte (original) -> ISDB information
$(tspath tsdump) --max-packets 20 --rs204 --isdb \
    $(fpath "$INFILE") \
    >$(fpath "$OUTDIR/$SCRIPT.3.txt") \
    2>"$OUTDIR/$SCRIPT.tsdump.3.log"

test_text $SCRIPT.tsdump.3.log
test_text $SCRIPT.3.txt

# 4) Input "tsdump" 204-byte (output of 1) -> ISDB information
$(tspath tsdump) --max-packets 20 --rs204 --isdb \
    $(fpath "$OUTDIR/$SCRIPT.1.ts") \
    >$(fpath "$OUTDIR/$SCRIPT.4.txt") \
    2>"$OUTDIR/$SCRIPT.tsdump.4.log"

test_text $SCRIPT.tsdump.4.log
test_text $SCRIPT.4.txt

# 5) Input "tsdump" 188-byte (output of 2) -> ISDB information (none expected)
$(tspath tsdump) --max-packets 20 --rs204 --isdb \
    $(fpath "$OUTDIR/$SCRIPT.2.ts") \
    >$(fpath "$OUTDIR/$SCRIPT.5.txt") \
    2>"$OUTDIR/$SCRIPT.tsdump.5.log"

test_text $SCRIPT.tsdump.5.log
test_text $SCRIPT.5.txt

# 6) Fork plugin, input, packet and output, all 204-byte.
test_tsp \
    -I fork "$(fpath $(tspath tsp)) -I file "$(fpath "$INFILE")" -P until --packets 20 -O file --format rs204" \
    -P fork --format rs204 "$(fpath $(tspath tsp)) -O file "$(fpath "$OUTDIR/$SCRIPT.6a.ts")" --format rs204" \
    -O fork --format rs204 "$(fpath $(tspath tsp)) -O file "$(fpath "$OUTDIR/$SCRIPT.6b.ts")" --format rs204" \
    >"$OUTDIR/$SCRIPT.tsp.6.log" 2>&1

test_text $SCRIPT.tsp.6.log
test_bin $SCRIPT.6a.ts
test_bin $SCRIPT.6b.ts

# 7) Merge plugin, all 204-byte.
test_tsp --bitrate 1000000 \
    -I null \
    -P regulate \
    -P merge --terminate \
       "$(fpath $(tspath tsp)) -I file "$(fpath "$INFILE")" -P filter -n -p 0x1FFF -P until --packets 3 -O file --format rs204" \
    -P filter -n -p 0x1FFF \
    -O file $(fpath "$OUTDIR/$SCRIPT.7.ts") --format rs204 \
    >"$OUTDIR/$SCRIPT.tsp.7.log" 2>&1

test_text $SCRIPT.tsp.7.log
test_bin $SCRIPT.7.ts

# 8) Input plugin craft, all 204-byte.
test_tsp \
    -I craft --rs204 DEADBEEF --pid 100 \
    -P until --packets 10 \
    -O file $(fpath "$OUTDIR/$SCRIPT.8.ts") --format rs204 \
    >"$OUTDIR/$SCRIPT.tsp.8.log" 2>&1

test_text $SCRIPT.tsp.8.log
test_bin $SCRIPT.8.ts

# 9) Packet plugin craft, all 204-byte.
test_tsp \
    -I craft --pid 100 \
    -P until --packets 10 \
    -P craft --rs204 DEADBEEF \
    -P filter --every 3 --set-label 1 \
    -P craft --only-label 1 --delete-rs204 \
    -P dump --rs204 -o $(fpath "$OUTDIR/$SCRIPT.9.txt") \
    -O file $(fpath "$OUTDIR/$SCRIPT.9.ts") --format rs204 \
    >"$OUTDIR/$SCRIPT.tsp.9.log" 2>&1

test_text $SCRIPT.tsp.9.log
test_text $SCRIPT.9.txt
test_bin $SCRIPT.9.ts

# 10) Output and input plugin "ip", all 204-byte.
# Cannot synchronize on first IP packet -> all packets must have same content for reproductibility.
test_tsp -b 1,000,000 --control-port 11234 \
    -I craft --rs204 DEADBEEF --pid 100 \
    -P regulate --packet-burst 7 \
    -O ip --rs204 127.0.0.1:11236 --enforce-burst --local-address 127.0.0.1 \
    >"$OUTDIR/$SCRIPT.tsp.10s.log" 2>&1 &

outpid=$!

test_tsp \
    -I ip 11236 --local-address 127.0.0.1 \
    -P until --packet 50 \
    -O file $(fpath "$OUTDIR/$SCRIPT.10.ts") --format rs204 \
    >"$OUTDIR/$SCRIPT.tsp.10r.log" 2>&1

$(tspath tspcontrol) --tsp 11234 exit
wait $outpid

test_text $SCRIPT.tsp.10s.log
test_text $SCRIPT.tsp.10r.log
test_bin $SCRIPT.10.ts

# 11) Input plugin "pcap", all 204-byte.
test_tsp \
    -I pcap $(fpath "$INDIR/$SCRIPT.11.pcapng") \
    -O file $(fpath "$OUTDIR/$SCRIPT.11.ts") --format rs204 \
    >"$OUTDIR/$SCRIPT.tsp.11.log" 2>&1

test_text $SCRIPT.tsp.11.log
test_bin $SCRIPT.11.ts

# 12) Output and input plugin "srt", all 204-byte.
# Run the test only if srt is supported on this platform
if $(tspath tsversion) --support srt; then

    test_tsp \
        -I craft --rs204 DEADBEEF --pid 100 \
        -O srt --listener 127.0.0.1:11238 --transtype live --rs204 \
        >"$OUTDIR/$SCRIPT.tsp.12s.log" 2>&1 &

    outpid=$!

    test_tsp \
        -I srt --caller 127.0.0.1:11238 --local-interface 127.0.0.1 --transtype live \
        -P until --packets 50 \
        -O file $(fpath "$OUTDIR/$SCRIPT.12.ts") --format rs204 \
        >"$OUTDIR/$SCRIPT.tsp.12r.log" 2>&1

    wait $outpid

    # Remove SRT logs, they are not deterministic.
    sed -i -e '/\/SRT:/d' -e '/:SRT\./d' "$OUTDIR/$SCRIPT.tsp.12s.log" "$OUTDIR/$SCRIPT.tsp.12r.log"

    test_text $SCRIPT.tsp.12s.log
    test_text $SCRIPT.tsp.12r.log
    test_bin $SCRIPT.12.ts

fi

# 13) Output and input plugin "rist", all 204-byte.
# Run the test only if rist is supported on this platform
if $(tspath tsversion) --support rist; then

    test_tsp -b 1,000,000 --control-port 11240 \
        -I craft --rs204 DEADBEEF --pid 100 \
        -P regulate \
        -O rist rist://127.0.0.1:11242 --rs204 \
        >"$OUTDIR/$SCRIPT.tsp.13s.log" 2>&1 &

    outpid=$!

    test_tsp \
        -I rist rist://@127.0.0.1:11242 \
        -P until --packets 50 \
        -O file $(fpath "$OUTDIR/$SCRIPT.13.ts") --format rs204 \
        >"$OUTDIR/$SCRIPT.tsp.13r.log" 2>&1

    $(tspath tspcontrol) --tsp 11240 exit
    wait $outpid

    # Remove RIST error messages about performances and response time.
    sed -i \
        -e '/rist:.*Failed to set .* scheduler/d' \
        -e '/rist:.*RIST receive queue /d' \
        -e '/rist:.*handshake is still pending /d' \
        "$OUTDIR/$SCRIPT.tsp.13s.log" "$OUTDIR/$SCRIPT.tsp.13r.log"

    test_text $SCRIPT.tsp.13s.log
    test_text $SCRIPT.tsp.13r.log
    test_bin $SCRIPT.13.ts

fi
