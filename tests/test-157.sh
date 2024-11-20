#!/usr/bin/env bash
# Multicast, ip, mpe and mpeinject plugins

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Transport streams:
# - TS1 : simple IP stream with only a PAT.
# - TS2 : simple IP stream with only a PAT.
# - TS3 : full TS with one MPE service, containing TS1 and TS2.
# - TS4 : same content as TS1, redirected outside TS3.
# - TS5 : same content as TS2, redirected outside TS3.

PAT1="<?xml version='1.0' encoding='UTF-8'?>
<tsduck>
  <PAT transport_stream_id='1'>
    <service service_id='10' program_map_PID='100'/>
    <service service_id='11' program_map_PID='110'/>
  </PAT>
</tsduck>"

PAT2="<?xml version='1.0' encoding='UTF-8'?>
<tsduck>
  <PAT transport_stream_id='2'>
    <service service_id='20' program_map_PID='200'/>
    <service service_id='21' program_map_PID='210'/>
    <service service_id='22' program_map_PID='220'/>
  </PAT>
</tsduck>"

# TS3 structure (MPE):
# - service 30: INT
#     PID 300: PMT
#     PID 301: INT sections
# - service 31: MPE
#     PID 310: PMT
#     PID 311: MPE sections, component tag 1

PAT3="<?xml version='1.0' encoding='UTF-8'?>
<tsduck>
  <PAT transport_stream_id='3'>
    <service service_id='30' program_map_PID='300'/>
    <service service_id='31' program_map_PID='310'/>
  </PAT>
</tsduck>"

SDT3="<?xml version='1.0' encoding='UTF-8'?>
<tsduck>
  <SDT transport_stream_id='3' original_network_id='1'>
    <service service_id='30' running_status='running'>
      <service_descriptor service_type='0x0C' service_name='MPE Demo (INT)' service_provider_name='TSDuck'/>
    </service>
    <service service_id='31' running_status='running'>
      <service_descriptor service_type='0x0C' service_name='MPE Demo' service_provider_name='TSDuck'/>
    </service>
  </SDT>
</tsduck>"

PMT3_INT="<?xml version='1.0' encoding='UTF-8'?>
<tsduck>
  <PMT service_id='30'>
    <component elementary_PID='301' stream_type='0x05'>
      <data_broadcast_id_descriptor data_broadcast_id='0x000B'/>
    </component>
  </PMT>
</tsduck>"

PMT3_MPE="<?xml version='1.0' encoding='UTF-8'?>
<tsduck>
  <PMT service_id='31'>
    <component elementary_PID='311' stream_type='0x0D'>
      <stream_identifier_descriptor component_tag='1'/>
      <data_broadcast_id_descriptor data_broadcast_id='0x0005'/>
    </component>
  </PMT>
</tsduck>"

INT3="<?xml version='1.0' encoding='UTF-8'?>
<tsduck>
  <INT platform_id='0x123456'>
    <device>
      <operational>
        <IPMAC_stream_location_descriptor
            network_id='1'
            original_network_id='1'
            transport_stream_id='3'
            service_id='31'
            component_tag='1'/>
      </operational>
    </device>
  </INT>
</tsduck>"

# Multicast is a strange beast.
# Distinct operating systems require distinct options.
# Here, we use localhost to send and receive multicast.
# This has several consequences:
# - On macOS and BSD systems, we need --force-local-multicast-outgoing to send.
# - On Windows, we need to start the receivers before the senders.
#   Sending packets on localhost without receivers is considered "unreachable".

[[ $OS == mac || $OS == *bsd ]] && FORCE="--force-local-multicast-outgoing" || FORCE=""

CONTROL1=9101
CONTROL2=9102
CONTROL3=9103

MC1=239.111.211.111:9201
MC2=239.112.212.112:9202
MC4=239.114.214.114:9204
MC5=239.115.215.115:9205

# Receive T4 and TS5. Save one table and terminate.
# Because of the multicast limitations on Windows, we need to start them first.

outpids=()

test_tsp \
    -I ip $MC4 --local-address $LOCALHOST \
    -P tables --pid 0 --max-tables 1 -o $(fpath "$OUTDIR/$SCRIPT.4.txt") -b $(fpath "$OUTDIR/$SCRIPT.4.bin") \
    -O drop \
    >"$OUTDIR/$SCRIPT.4.log" 2>&1 &
outpids+=($!)

test_tsp \
    -I ip $MC5 --local-address $LOCALHOST \
    -P tables --pid 0 --max-tables 1 -o $(fpath "$OUTDIR/$SCRIPT.5.txt") -b $(fpath "$OUTDIR/$SCRIPT.5.bin") \
    -O drop \
    >"$OUTDIR/$SCRIPT.5.log" 2>&1 &
outpids+=($!)

# Start TS1 and TS2 in the background.

inpids=()

test_tsp --bitrate 100,000 --control-port $CONTROL1 --control-source $LOCALHOST \
    -I null \
    -P regulate --packet-burst 14 \
    -P inject "$PAT1" --pid 0 --bitrate 15000 --stuffing \
    -O ip $MC1 --enforce-burst --local-address $LOCALHOST $FORCE \
    >"$OUTDIR/$SCRIPT.1.log" 2>&1 &
inpids+=($!)

test_tsp --bitrate 100,000 --control-port $CONTROL2 --control-source $LOCALHOST \
    -I null \
    -P regulate --packet-burst 14 \
    -P inject "$PAT2" --pid 0 --bitrate 15000 --stuffing \
    -O ip $MC2 --enforce-burst --local-address $LOCALHOST $FORCE \
    >"$OUTDIR/$SCRIPT.2.log" 2>&1 &
inpids+=($!)

# Start T3 in the background.
# Encapsulate TS1 and TS2 in MPE PID and rename their redistination for TS4 and TS5.
# Extract TS4 and TS5 from MPE PID and forward them over UDP.

test_tsp --bitrate 500,000 --control-port $CONTROL3 --control-source $LOCALHOST \
    -I null \
    -P regulate \
    -P inject "$PAT3" --pid 0 --bitrate 15000 \
    -P inject "$SDT3" --pid 17 --bitrate 15000 \
    -P inject "$PMT3_INT" --pid 300 --bitrate 15000 \
    -P inject "$INT3" --pid 301 --bitrate 15000 \
    -P inject "$PMT3_MPE" --pid 310 --bitrate 15000 \
    -P mpeinject --pid 311 --max-queue 512 --local-address $LOCALHOST \
        $MC1 --new-destination $MC4 \
        $MC2 --new-destination $MC5 \
    -P mpe --udp-forward --local-address $LOCALHOST \
    -O drop \
    >"$OUTDIR/$SCRIPT.3.log" 2>&1 &
inpids+=($!)

# Terminate all background process and synchronously wait for them.

wait ${outpids[*]}
$(tspath tspcontrol) -t $CONTROL1 exit >"$OUTDIR/$SCRIPT.exit.1.log" 2>&1
$(tspath tspcontrol) -t $CONTROL2 exit >"$OUTDIR/$SCRIPT.exit.2.log" 2>&1
$(tspath tspcontrol) -t $CONTROL3 exit >"$OUTDIR/$SCRIPT.exit.3.log" 2>&1
wait ${inpids[*]}

test_text $SCRIPT.1.log
test_text $SCRIPT.2.log
test_text $SCRIPT.3.log
test_text $SCRIPT.4.log
test_text $SCRIPT.4.txt
test_bin  $SCRIPT.4.bin
test_text $SCRIPT.5.log
test_text $SCRIPT.5.txt
test_bin  $SCRIPT.5.bin
test_text $SCRIPT.exit.1.log
test_text $SCRIPT.exit.2.log
test_text $SCRIPT.exit.3.log
