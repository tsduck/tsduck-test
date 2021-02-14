#!/bin/bash
# EIT normalization

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Looking for GNU date command: "gdate" first, then "date" if not found.
DATE=$(which gdate 2>/dev/null)
DATE=${DATE:-date}

# The input XML file is built from an initial file plus a lot of generated EIT.
XMLFILE="$TMPDIR/$SCRIPT.xml"
(
    grep -v '</tsduck>' "$INDIR/$SCRIPT.xml"

    # Events to generate
    EVENT_ID=3000
    EVENT_DATE=$($DATE -d "2020-06-13 05:00:00" +%s)
    EVENT_COUNT=100
    DESC_COUNT=8

    # 200-character string
    string200=
    for ((i=0; $i < 200; i++)); do
        string200="=$string200"
    done

    # Generate one big EIT.
    echo '  <EIT type="0" actual="false" service_id="2" transport_stream_id="20" original_network_id="20">'
    
    # Generate events
    for ((i=0; $i < $EVENT_COUNT; i++)); do
        evdate=$($DATE -d @$EVENT_DATE '+%Y-%m-%d %H:%M:%S')
        printf '    <event event_id="%d" start_time="%s" duration="00:01:00">\n' $EVENT_ID "$evdate"
        for ((desc=0; $desc < $DESC_COUNT; desc++)); do
            printf '      <short_event_descriptor language_code="foo">\n'
            printf '        <event_name>Event %s</event_name>\n' $EVENT_ID
            printf '        <text>Descriptor %d %s</text>\n' $desc "$string200"
            printf '      </short_event_descriptor>\n'
        done
        echo '    </event>'
        EVENT_ID=$(( $EVENT_ID + 1 ))
        EVENT_DATE=$(( $EVENT_DATE + 60 ))
    done
    
    echo '  </EIT>'
    echo ''
    echo '</tsduck>'
) >"$XMLFILE"

# Without EIT normalization
$(tspath tstabcomp) \
    $(fpath "$XMLFILE") \
    -o $(fpath "$OUTDIR/$SCRIPT.1.bin") \
    >"$OUTDIR/$SCRIPT.comp.1.log" 2>&1

test_text $SCRIPT.comp.1.log
test_bin $SCRIPT.1.bin

$(tspath tstabdump) $(fpath "$OUTDIR/$SCRIPT.1.bin") \
    >"$OUTDIR/$SCRIPT.1.txt" 2>"$OUTDIR/$SCRIPT.dump.1.log"

test_text $SCRIPT.dump.1.log
test_text $SCRIPT.1.txt

# Using default time base
$(tspath tstabcomp) --eit-normalization \
    $(fpath "$XMLFILE") \
    -o $(fpath "$OUTDIR/$SCRIPT.2.bin") \
    >"$OUTDIR/$SCRIPT.comp.2.log" 2>&1

test_text $SCRIPT.comp.2.log
test_bin $SCRIPT.2.bin

$(tspath tstabdump) $(fpath "$OUTDIR/$SCRIPT.2.bin") \
    >"$OUTDIR/$SCRIPT.2.txt" 2>"$OUTDIR/$SCRIPT.dump.2.log"

test_text $SCRIPT.dump.2.log
test_text $SCRIPT.2.txt

# Using explicit time base
$(tspath tstabcomp) --eit-normalization --eit-base-date 2020/06/09 \
    $(fpath "$XMLFILE") \
    -o $(fpath "$OUTDIR/$SCRIPT.3.bin") \
    >"$OUTDIR/$SCRIPT.comp.3.log" 2>&1

test_text $SCRIPT.comp.3.log
test_bin $SCRIPT.3.bin

$(tspath tstabdump) $(fpath "$OUTDIR/$SCRIPT.3.bin") \
    >"$OUTDIR/$SCRIPT.3.txt" 2>"$OUTDIR/$SCRIPT.dump.3.log"

test_text $SCRIPT.dump.3.log
test_text $SCRIPT.3.txt
