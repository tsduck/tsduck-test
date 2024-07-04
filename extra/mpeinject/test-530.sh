#!/usr/bin/env bash
# Test plugin mpeinject with multiple UDP streams.

source $(dirname $0)/../../common/testrc.sh
cd $(dirname "$0")

# Service plan:
# - service 700: INT
#     PID 5000: PMT
#     PID 5001: INT sections
# - service 701: MPE
#     PID 5002: PMT
#     PID 5003: MPE section, component tag 1

PAT="<?xml version='1.0' encoding='UTF-8'?>
<tsduck>
  <PAT transport_stream_id='1'>
    <service service_id='700' program_map_PID='5000'/>
    <service service_id='701' program_map_PID='5002'/>
  </PAT>
</tsduck>"

SDT="<?xml version='1.0' encoding='UTF-8'?>
<tsduck>
  <SDT transport_stream_id='1' original_network_id='1'>
    <service service_id='700' running_status='running'>
      <service_descriptor service_type='0x0C' service_name='MPE Demo (INT)' service_provider_name='TSDuck'/>
    </service>
    <service service_id='701' running_status='running'>
      <service_descriptor service_type='0x0C' service_name='MPE Demo' service_provider_name='TSDuck'/>
    </service>
  </SDT>
</tsduck>"

PMT_INT="<?xml version='1.0' encoding='UTF-8'?>
<tsduck>
  <PMT service_id='700'>
    <component elementary_PID='5001' stream_type='0x05'>
      <data_broadcast_id_descriptor data_broadcast_id='0x000B'/>
    </component>
  </PMT>
</tsduck>"

PMT_MPE="<?xml version='1.0' encoding='UTF-8'?>
<tsduck>
  <PMT service_id='701'>
    <component elementary_PID='5003' stream_type='0x0D'>
      <stream_identifier_descriptor component_tag='1'/>
      <data_broadcast_id_descriptor data_broadcast_id='0x0005'/>
    </component>
  </PMT>
</tsduck>"

INT="<?xml version='1.0' encoding='UTF-8'?>
<tsduck>
  <INT platform_id='0x123456'>
    <IPMAC_platform_name_descriptor language_code='eng' text='Test'/>
    <IPMAC_platform_provider_name_descriptor language_code='eng' text='TSDuck'/>
    <device>
      <target>
        <target_IP_slash_descriptor>
          <address IPv4_addr='230.2.3.11' IPv4_slash_mask='32'/>
          <address IPv4_addr='230.2.3.12' IPv4_slash_mask='32'/>
          <address IPv4_addr='230.2.3.13' IPv4_slash_mask='32'/>
        </target_IP_slash_descriptor>
      </target>
      <operational>
        <IPMAC_stream_location_descriptor
            network_id='1'
            original_network_id='1'
            transport_stream_id='1'
            service_id='701'
            component_tag='1'/>
      </operational>
    </device>
  </INT>
</tsduck>"

# This script is invoked recursively.
case "$1" in
    --send)
        # Send UDP messages at regular intervals.
        index=$2
        count=$3
        port=$((11000 + $index))
        while [[ $count -gt 0 ]]; do
            sleep $index
            echo Test.$index >/dev/udp/127.0.0.1/$port
            count=$(($count - 1))
        done
        ;;
    "")
        # Main command.
        # Create 3 sender processes during 30 seconds.
        pids=()
        ./$SCRIPT.sh --args '--send 1 30' &
        pids+=($!)
        ./$SCRIPT.sh --args '--send 2 15' &
        pids+=($!)
        ./$SCRIPT.sh --args '--send 3 10' &
        pids+=($!)
        # Encapsulate the 3 UDP streams into one single MPE PID.
        $(tspath tsp) --verbose --bitrate 12,000,000 --max-flushed-packets 70 --timed-log \
            -I null \
            -P regulate --packet-burst 14 \
            -P until --seconds 35 \
            -P inject "$PAT" --pid 0 --bitrate 15000 \
            -P inject "$SDT" --pid 17 --bitrate 15000 \
            -P inject "$PMT_INT" --pid 5000 --bitrate 15000 \
            -P inject "$INT" --pid 5001 --bitrate 15000 \
            -P inject "$PMT_MPE" --pid 5002 --bitrate 15000 \
            -P mpeinject --pid 5003 --max-queue 512 \
                11001 --new-source 192.168.99.1:8001 --new-destination 230.1.2.11:9001 \
                11002 --new-source 192.168.99.2:8002 --new-destination 230.1.2.12:9002 \
                11003 --new-source 192.168.99.3:8003 --new-destination 230.1.2.13:9003 \
            -P mpe --log --dump-datagram \
            -P analyze -o $SCRIPT.analysis.log \
            -P tables -o $SCRIPT.tables.log \
            -O drop \
            >$SCRIPT.tsp.log 2>&1
        grep "mpe: PID" $SCRIPT.tsp.log >$SCRIPT.traces.log
        wait ${pids[*]}
        ;;
    *)
        error "unknown parameter $1"
        ;;
esac
