#!/usr/bin/env bash
# Check the integrity of help texts.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Some tools and plugins have output texts which depend on the operating system.
# Some others are not implemented at all (eg. dektec plugins on macOS).
# Tests named NAME.OS are executed on OS only, using name NAME.OS.
# Tests named NAME/OS1/OS2/... are not executed on OS1, OS2, ...
# and are executed elsewhere using name NAME.

TOOLS=(
    tsanalyze tsbitrate tscharset tscmp tscrc32 tsdate tsdektec
    tsdump tsecmg tseit tsemmg tsfclean tsfixcc tsftrunc tsfuzz tsgenecm
    tshides tslatencymonitor
    tslsdvb.linux tslsdvb.mac tslsdvb.windows
    tsp tspacketize tspcap tspcontrol tspsi tsresync
    tsscan.linux tsscan.mac tsscan.windows
    tssmartcard tsstuff tsswitch tstabcomp tstabdump tstables tsterinfo
    tstestecmg tsvatek
)

INPUT_PLUGINS=(
    craft dektec dvb.linux dvb.mac dvb.windows file fork
    hls http ip memory null pcap rist srt
)

OUTPUT_PLUGINS=(
    dektec.linux dektec.windows drop file fork hides hls http ip memory
    play.linux play.mac play.windows rist srt vatek
)

PACKET_PLUGINS=(
    aes analyze bat bitrate_monitor boostpid cat clear continuity count
    craft cutoff datainject descrambler dump duplicate eit eitinject feed file filter
    fork fuzz history inject ip limit merge mpe mpeinject mux nit nitscan pat pattern
    pcradjust pcrbitrate pcrcopy pcredit pcrextract pcrverify pes pidshift pmt
    psi psimerge reduce regulate remap rmorphan rmsplice scrambler sdt sections
    sifilter skip slice spliceinject splicemonitor stats stuffanalyze
    svremove svrename svresync t2mi tables teletext time timeref timeshift
    trigger tsrename until zap
)

# Check if a tool or plugin name shall be tested.
valid-test()
{
    # Skip tests on unsupported features.
    for feat in dektec hides rist srt vatek; do
        if [[ $1 == *${feat}* ]]; then
            $(tspath tsversion) --support $feat || return $EXIT_FAILURE
        fi
    done
    # No OS-specific indication:
    [[ $1 != *.* && $1 != */* ]] && return $EXIT_SUCCESS
    # Test for that specific OS: 
    [[ $1 == *.$OS || $1 == *.$OS2 ]] && return $EXIT_SUCCESS
    # Test for another OS:
    [[ $1 == *.* ]] && return $EXIT_FAILURE
    # Test excluded for that specific OS:
    [[ $1/ == */$OS/* || $1/ == */$OS2/* ]] && return $EXIT_FAILURE
    # Test not excluded for that specific OS:
    return $EXIT_SUCCESS
}

for name in ${TOOLS[@]}; do
    if valid-test $name; then
        name=${name/\/*/}
        $(trace $(tspath ${name/.*/}) --help >"$OUTDIR/$SCRIPT.$name.help")
        $(tspath ${name/.*/}) --help >"$OUTDIR/$SCRIPT.$name.help" 2>&1
        $(trace test_text $SCRIPT.$name.help)
        test_text $SCRIPT.$name.help
    fi
done

for name in ${INPUT_PLUGINS[@]}; do
    if valid-test $name; then
        name=${name/\/*/}
        $(trace $(tspath tsp) -I ${name/.*/} --help >"$OUTDIR/$SCRIPT.tsp.input.$name.help")
        $(tspath tsp) -I ${name/.*/} --help >"$OUTDIR/$SCRIPT.tsp.input.$name.help" 2>&1
        $(trace test_text $SCRIPT.tsp.input.$name.help)
        test_text $SCRIPT.tsp.input.$name.help
    fi
done

for name in ${OUTPUT_PLUGINS[@]}; do
    if valid-test $name; then
        name=${name/\/*/}
        $(trace $(tspath tsp) -O ${name/.*/} --help >"$OUTDIR/$SCRIPT.tsp.output.$name.help")
        $(tspath tsp) -O ${name/.*/} --help >"$OUTDIR/$SCRIPT.tsp.output.$name.help" 2>&1
        $(trace test_text $SCRIPT.tsp.output.$name.help)
        test_text $SCRIPT.tsp.output.$name.help
    fi
done

for name in ${PACKET_PLUGINS[@]}; do
    if valid-test $name; then
        name=${name/\/*/}
        $(trace $(tspath tsp) -P ${name/.*/} --help >"$OUTDIR/$SCRIPT.tsp.packet.$name.help")
        $(tspath tsp) -P ${name/.*/} --help >"$OUTDIR/$SCRIPT.tsp.packet.$name.help" 2>&1
        $(trace test_text $SCRIPT.tsp.packet.$name.help)
        test_text $SCRIPT.tsp.packet.$name.help
    fi
done
