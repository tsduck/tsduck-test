#!/usr/bin/env bash
# Test Java on memory plugin

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
native_only
exclude_on_asan

INFILE="$INDIR/test-001.ts"
OUTFILE="$TMPDIR/$SCRIPT.ts"

WORKDIR="$TMPDIR/$SCRIPT.d"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# Verify that tsduck.jar was compiled with Java 8 compatibility.
(
    cp "$TSDUCKJAR" tsduck.jar
    "$JAR" xf tsduck.jar
    "$JAVAP" -verbose io/tsduck/Info.class | grep version:
) >"$OUTDIR/$SCRIPT.version.log" 2>&1

test_text $SCRIPT.version.log

# Test Java application

(
    cp "$INDIR/$SCRIPT.java" Test087.java
    "$JAVAC" Test087.java
) >"$OUTDIR/$SCRIPT.javac.log" 2>&1

test_text $SCRIPT.javac.log

"$JAVA" $JAVA_FLAGS Test087 $(fpath "$INFILE") $(fpath "$OUTFILE") >"$OUTDIR/$SCRIPT.java.log" 2>&1

test_text $SCRIPT.java.log

# We don't store the output file. It is large and should be identical
# to the input one. So, we just store the result of the comparison.

$(tspath tscmp) --continue "$INFILE" "$OUTFILE" >"$OUTDIR/$SCRIPT.tscmp.log" 2>&1

test_text $SCRIPT.tscmp.log
