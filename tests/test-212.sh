#!/usr/bin/env bash
# More than 85 services in a service_list_descriptor

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Build the common SDT in XML format.
SDTXML="$TMPDIR/$SCRIPT.sdt.xml"
echo >"$SDTXML" '<?xml version="1.0" encoding="UTF-8"?>'
echo >>"$SDTXML" '<tsduck><SDT transport_stream_id="1" original_network_id="2"/></tsduck>'

# A function to perform a test with a given number of services.
service_list_descriptor_test() {
    local index=$1
    local service_count=$2
    local patxml="$TMPDIR/$SCRIPT.pat.$index.xml"

    # Build the PAT in XML format.
    echo >"$patxml" '<?xml version="1.0" encoding="UTF-8"?>'
    echo >>"$patxml" '<tsduck><PAT transport_stream_id="1">'
    for ((id=1; $id<=$service_count; id++)); do
        pid=$(( 100 + $id ))
        echo >>"$patxml" "<service service_id='$id' program_map_PID='$pid'/>"
    done
    echo >>"$patxml" '</PAT></tsduck>'

    test_tsp -b 1,000,000 \
        -I null \
        -P inject $(fpath "$patxml") --pid 0 --inter-packet 10 --stuffing \
        -P inject $(fpath "$SDTXML") --pid 17 --inter-packet 10 --stuffing \
        -P nit --create --build-service-list-descriptors --default-service-type 1 \
        -P tables -j -x 1 --pid 0 -o $(fpath "$OUTDIR/$SCRIPT.pat.$index.txt") \
        -P tables -j -x 1 --pid 16 -o $(fpath "$OUTDIR/$SCRIPT.nit.$index.txt") \
        -P tables -j -x 1 --pid 17 -o $(fpath "$OUTDIR/$SCRIPT.sdt.$index.txt") \
        -O drop \
        >"$OUTDIR/$SCRIPT.$index.log" 2>&1

    test_text $SCRIPT.$index.log
    test_text $SCRIPT.pat.$index.txt
    test_text $SCRIPT.nit.$index.txt
    test_text $SCRIPT.sdt.$index.txt
}

service_list_descriptor_test 1 80
service_list_descriptor_test 2 180
