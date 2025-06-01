#!/usr/bin/env bash
# Test Java bindings.

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"
native_only
exclude_on_asan

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
    cp "$INDIR/$SCRIPT.java" Test081.java
    "$JAVAC" Test081.java
) >"$OUTDIR/$SCRIPT.javac.log" 2>&1

test_text $SCRIPT.javac.log

"$JAVA" $JAVA_FLAGS Test081 $(fpath "$INDIR/test-001.ts") >"$OUTDIR/$SCRIPT.java.log" 2>&1

test_text $SCRIPT.java.log
