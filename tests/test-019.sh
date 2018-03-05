#!/bin/bash
# Check the integrity of help texts.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

TOOLS=(
    tsanalyze tsbitrate tscmp tsdate tsdektec tsdump tsfixcc tsftrunc tslsdvb
    tspacketize tsp tspsi tsresync tsscan tssmartcard tsstuff tstabcomp
    tstabdump tstables tsterinfo tsversion
)

INPUT_PLUGINS=(
    dektec dvb file ip null
)

OUTPUT_PLUGINS=(
    dektec drop file ip play
)

PACKET_PLUGINS=(
    aes analyze bat bitrate_monitor boostpid cat clear continuity count
    datainject descrambler eit file filter fork history inject mux nit
    nitscan pat pattern pcrbitrate pcrextract pcrverify pes pmt psi reduce
    regulate remap rmorphan rmsplice scrambler sdt sifilter skip slice
    stuffanalyze svremove svrename t2mi tables teletext time timeref
    tsrename until zap
)

for cmd in ${TOOLS[@]}; do
    $(tspath $cmd) --help >"$OUTDIR/$SCRIPT.$cmd.help" 2>&1
    test_text $SCRIPT.$cmd.help
done

for plug in ${INPUT_PLUGINS[@]}; do
    $(tspath tsp) -I $plug --help >"$OUTDIR/$SCRIPT.tsp.input.$plug.help" 2>&1
    test_text $SCRIPT.tsp.input.$plug.help
done

for plug in ${OUTPUT_PLUGINS[@]}; do
    $(tspath tsp) -O $plug --help >"$OUTDIR/$SCRIPT.tsp.output.$plug.help" 2>&1
    test_text $SCRIPT.tsp.output.$plug.help
done

for plug in ${PACKET_PLUGINS[@]}; do
    $(tspath tsp) -P $plug --help >"$OUTDIR/$SCRIPT.tsp.packet.$plug.help" 2>&1
    test_text $SCRIPT.tsp.packet.$plug.help
done
