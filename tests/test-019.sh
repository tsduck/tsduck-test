#!/usr/bin/env bash
# Check the integrity of help texts.

source $(dirname $0)/../common/testrc.sh

# Important: do not call test_cleanup on --init. This would delete help files
# on features which are not supported on this platform.
if $INITEST; then
    OUTFILES=$(test_outputs "$SCRIPT.*")
else
    test_cleanup "$SCRIPT.*"
    OUTFILES=""
fi

# Some tools and plugins have output texts which depend on the operating system.
# Some others are not implemented at all (eg. dektec plugins on macOS).
# Tests named NAME.OS are executed on OS only, using name NAME.OS.

TOOLS=(
    tsanalyze tsbitrate tscharset tscmp tscrc32 tsdate tsdektec
    tsdump tsecmg tseit tsemmg tsfclean tsfixcc tsftrunc tsfuzz tsgenecm
    tshides tslatencymonitor
    tslsdvb.linux tslsdvb.mac tslsdvb.windows
    tsp tspacketize tspcap tspcontrol tspsi tsresync
    tsscan.linux tsscan.mac tsscan.windows
    tssmartcard tsstuff tsswitch tstabcomp tstabdump tstables tsterinfo
    tstestecmg tsvatek tsxml
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
    trace trigger tsrename until zap
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
    [[ $1 != *.* ]] && return $EXIT_SUCCESS
    # Test for that specific OS: 
    [[ $1 == *.$OS || $1 == *.$OS2 ]] && return $EXIT_SUCCESS
    # Test for another OS:
    [[ $1 == *.* ]] && return $EXIT_FAILURE
    # Test not excluded for any OS:
    return $EXIT_SUCCESS
}

for tname in ${TOOLS[@]}; do
    name=${tname/\/*/}
    file="$SCRIPT.$name.help"
    if valid-test $tname; then
        $INITEST && rm -rf "$OUTDIR/$file"
        $(trace $(tspath ${name/.*/}) --help >"$OUTDIR/$file")
        $(tspath ${name/.*/}) --help >"$OUTDIR/$file" 2>&1
        $(trace test_text $file)
        test_text $file
    fi
done

for tname in ${INPUT_PLUGINS[@]}; do
    name=${tname/\/*/}
    file="$SCRIPT.tsp.input.$name.help"
    if valid-test $tname; then
        $INITEST && rm -rf "$OUTDIR/$file"
        $(trace $(tspath tsp) -I ${name/.*/} --help >"$OUTDIR/$file")
        $(tspath tsp) -I ${name/.*/} --help >"$OUTDIR/$file" 2>&1
        $(trace test_text $file)
        test_text $file
    fi
done

for tname in ${OUTPUT_PLUGINS[@]}; do
    name=${tname/\/*/}
    file="$SCRIPT.tsp.output.$name.help"
    if valid-test $tname; then
        $INITEST && rm -rf "$OUTDIR/$file"
        $(trace $(tspath tsp) -O ${name/.*/} --help >"$OUTDIR/$file")
        $(tspath tsp) -O ${name/.*/} --help >"$OUTDIR/$file" 2>&1
        $(trace test_text $file)
        test_text $file
    fi
done

for tname in ${PACKET_PLUGINS[@]}; do
    name=${tname/\/*/}
    file="$SCRIPT.tsp.packet.$name.help"
    if valid-test $tname; then
        $INITEST && rm -rf "$OUTDIR/$file"
        $(trace $(tspath tsp) -P ${name/.*/} --help >"$OUTDIR/$file")
        $(tspath tsp) -P ${name/.*/} --help >"$OUTDIR/$file" 2>&1
        $(trace test_text $file)
        test_text $file
    fi
done
