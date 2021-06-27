#!/bin/bash
# Check the integrity of help texts.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

# Some tools and plugins have output texts which depend on the operating system.
# Their name is preceded by an equal sign, meaning that there is one reference
# file per operating system.

TOOLS=(
    tsanalyze tsbitrate tscharset tscmp tsdate tsdektec tsdump tsecmg tsemmg tsfclean
    tsfixcc tsftrunc tsgenecm tshides =tslsdvb tsp tspacketize tspcontrol tspsi tsresync
    =tsscan tssmartcard tsstuff tsswitch tstabcomp tstabdump tstables tsterinfo tsxml
)

INPUT_PLUGINS=(
    craft =dektec =dvb file fork hls http ip memory null pcap srt
)

OUTPUT_PLUGINS=(
    =dektec drop file fork hides hls ip memory =play srt
)

PACKET_PLUGINS=(
    aes analyze bat bitrate_monitor boostpid cat clear continuity count
    craft cutoff datainject descrambler duplicate eit eitinject file filter
    fork history inject limit merge mpe mpeinject mux nit nitscan pat pattern
    pcradjust pcrbitrate pcrcopy pcredit pcrextract pcrverify pes pidshift pmt
    psi psimerge reduce regulate remap rmorphan rmsplice scrambler sdt sections
    sifilter skip slice spliceinject splicemonitor stats stuffanalyze
    svremove svrename svresync t2mi tables teletext time timeref timeshift
    trigger tsrename until zap
)

helpfile() { [[ "$1" == =* ]] && echo ${1/=/}.$OS.help || echo $1.help; }

for name in ${TOOLS[@]}; do
    $(tspath ${name/=/}) --help >"$OUTDIR/$SCRIPT.$(helpfile $name)" 2>&1
    test_text $SCRIPT.$(helpfile $name)
done

for name in ${INPUT_PLUGINS[@]}; do
    $(tspath tsp) -I ${name/=/} --help >"$OUTDIR/$SCRIPT.tsp.input.$(helpfile $name)" 2>&1
    test_text $SCRIPT.tsp.input.$(helpfile $name)
done

for name in ${OUTPUT_PLUGINS[@]}; do
    $(tspath tsp) -O ${name/=/} --help >"$OUTDIR/$SCRIPT.tsp.output.$(helpfile $name)" 2>&1
    test_text $SCRIPT.tsp.output.$(helpfile $name)
done

for name in ${PACKET_PLUGINS[@]}; do
    $(tspath tsp) -P ${name/=/} --help >"$OUTDIR/$SCRIPT.tsp.packet.$(helpfile $name)" 2>&1
    test_text $SCRIPT.tsp.packet.$(helpfile $name)
done
