#!/bin/bash
# Test "pes" plugin with access unit analysis.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

for type in mpeg2 avc hevc; do

    # Analyze the file to get the first audio and video PID.
    $(tspath tsanalyze) $(fpath "$INDIR/$SCRIPT.$type.ts") --normalized --deterministic \
        >"$OUTDIR/$SCRIPT.$type.tsanalyze.txt" \
        2>"$OUTDIR/$SCRIPT.$type.tsanalyze.log"

    test_text $SCRIPT.$type.tsanalyze.txt
    test_text $SCRIPT.$type.tsanalyze.log

    # Get the first audio and video PID.
    apid=$(grep '^pid:' "$OUTDIR/$SCRIPT.$type.tsanalyze.txt" | grep ':audio:' | head -1 | sed -e 's/.*:pid=//' -e 's/:.*//')
    vpid=$(grep '^pid:' "$OUTDIR/$SCRIPT.$type.tsanalyze.txt" | grep ':video:' | head -1 | sed -e 's/.*:pid=//' -e 's/:.*//')

    # Common "pes" options.
    opt="--packet-index --max-dump-size 16"
    
    $(tspath tsp) --synchronous-log \
        -I file $(fpath "$INDIR/$SCRIPT.$type.ts") \
        -P pes $opt --pid $apid --audio-attributes -o $(fpath "$OUTDIR/$SCRIPT.$type.aattr.txt") \
        -P pes $opt --pid $apid --header --payload -o $(fpath "$OUTDIR/$SCRIPT.$type.apes.txt") \
        -P pes $opt --pid $vpid --video-attributes -o $(fpath "$OUTDIR/$SCRIPT.$type.vattr.txt") \
        -P pes $opt --pid $vpid --header --payload -o $(fpath "$OUTDIR/$SCRIPT.$type.vpes.txt") \
        -P pes $opt --pid $vpid --intra-image -o $(fpath "$OUTDIR/$SCRIPT.$type.intra.txt") \
        -P pes $opt --pid $vpid --avc-access-unit -o $(fpath "$OUTDIR/$SCRIPT.$type.nalunits.txt") \
        -P pes $opt --pid $vpid --sei-avc -o $(fpath "$OUTDIR/$SCRIPT.$type.sei.txt") \
        -P pes $opt --pid $vpid --pid $apid --save-pes $(fpath "$OUTDIR/$SCRIPT.$type.pes") \
        -P pes $opt --pid $vpid --save-es $(fpath "$OUTDIR/$SCRIPT.$type.video.es") \
        -P pes $opt --pid $apid --save-es $(fpath "$OUTDIR/$SCRIPT.$type.audio.es") \
        -O drop \
        >"$OUTDIR/$SCRIPT.$type.log" 2>&1

    test_text $SCRIPT.$type.aattr.txt
    test_text $SCRIPT.$type.apes.txt
    test_text $SCRIPT.$type.vattr.txt
    test_text $SCRIPT.$type.vpes.txt
    test_text $SCRIPT.$type.intra.txt
    test_text $SCRIPT.$type.nalunits.txt
    test_text $SCRIPT.$type.sei.txt
    test_bin  $SCRIPT.$type.pes
    test_text $SCRIPT.$type.log

done
