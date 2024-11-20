#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# This file shall be source'd by all test scripts.
# It parses the common command line options and defines variables and functions.
# ------------------------------------------------------------------------------

# Build script name from caller's name.
if [ ${#BASH_SOURCE[*]} -gt 1 ]; then
    SCRIPT=$(basename ${BASH_SOURCE[1]} .sh)
    SCRIPTDIR=$(cd $(dirname ${BASH_SOURCE[1]}); pwd)
fi

# Root directory of test repository and subdirs.
COMMONDIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)
ROOTDIR=$(cd "$COMMONDIR/.."; pwd)
TESTSDIR="$ROOTDIR/tests"
INDIR="$ROOTDIR/input"
REFDIR="$ROOTDIR/reference/$SCRIPT"
TMPDIR="$ROOTDIR/tmp"

# Additional command line arguments for the test script.
ARGS=""

# Root directory of TSDuck repository, supposed to be cloned at same level.
TSDUCKDIR=$(cd "$ROOTDIR/.."; pwd)/tsduck

# Default values for command line options.
DEVEL=false
NATIVE=true
TESTINIT=false
VERBOSE=false

# Output line prefixes.
PRPASS="----"
PRFAIL="XXXX"
PRVOID="    "

# Exit codes
EXIT_SUCCESS=0
EXIT_FAILURE=1

# A consistent way of using IPv4 localhost.
# Don't use the name "localhost", it can translate to an IPv4 or IPv6 address.
LOCALHOST=127.0.0.1

# Functions to report messages.
error() { echo >&2 "$SCRIPT: $*"; exit $EXIT_FAILURE; }
info()  { echo >&2 "$*"; }
trace() { $VERBOSE && info "$PRVOID  $*"; }
usage() { echo >&2 "invalid command, try \"$SCRIPT --help\""; exit $EXIT_FAILURE; }

# Use GNU variants of sed and grep when available.
unalias sed grep 2>/dev/null
[[ -n "$(which gsed 2>/dev/null)" ]] && sed() { gsed "$@"; }
[[ -n "$(which ggrep 2>/dev/null)" ]] && grep() { ggrep "$@"; }

# Prefix of a file path (remove extension).
prefix() { sed -e 's/\.[^\.]*$//' <<<$1; }

# Operating system.
OS=$(uname -s | tr A-Z a-z)
CPU=$(uname -m | tr A-Z a-z)
SYS64=false

case $OS in
    cygwin*)
        OS=windows
        [[ -d '/cygdrive/c/Program Files (x86)' ]] && SYS64=true
        ;;
    msys*|mingw*)
        OS=windows
        [[ -d '/c/Program Files (x86)' ]] && SYS64=true
        ;;
    darwin)
        OS=mac
        [[ $CPU == *64 || $CPU == *64e ]] && SYS64=true
        BREWPREFIX=$(brew --prefix)
        export PATH="$BREWPREFIX/bin:$PATH"
        ;;
    *)
        [[ $CPU == *64 ]] && SYS64=true
        ;;
esac

# All operating systems and "other" operating systems.
ALLOS="linux mac freebsd netbsd dragonfly openbsd windows"
OTHEROS=${ALLOS/$OS/}

# Alternative operating system name.
if [[ $OS != windows ]]; then
    OS2=$OS
elif $SYS64; then
    OS2=$OS-64
else
    OS2=$OS-32
fi

# Detect various types of UNIX-like environments on UNIX.
if [[ $OS == windows ]]; then
    WINDOWS=true
    TSDUCKBIN_ROOT=$TSDUCKDIR/bin
    TSDUCKBIN_RELEASE=$TSDUCKBIN_ROOT/Release-x64
    TSDUCKBIN_DEBUG=$TSDUCKBIN_ROOT/Debug-x64
    TSDUCKBIN32_RELEASE=$TSDUCKBIN_ROOT/Release-Win32
    TSDUCKBIN32_DEBUG=$TSDUCKBIN_ROOT/Debug-Win32
    EXE=.exe
else
    WINDOWS=false
    ARCH=${CPU/i?86/i386}
    ARCH=${ARCH/arm*/arm}
    TSDUCKBIN_RELEASE=$($TSDUCKDIR/scripts/setenv.sh --display)
    TSDUCKBIN_DEBUG=$($TSDUCKDIR/scripts/setenv.sh --display --debug)
    TSDUCKBIN32_RELEASE=${TSDUCKBIN_RELEASE/x86_64/i386}
    TSDUCKBIN32_DEBUG=${TSDUCKBIN_DEBUG/x86_64/i386}
    EXE=
fi

# "Unusual" CPU architectures may indicate a Qemu emulated environment.
# Use a 10 times longer timeout for tests since the emulation is very slow.
# The concept of "unusual" CPU architecture is completely arbitrary.
# If you have a better way to detect Qemu, please submit a PR.
[[ $CPU != x86_64 && $CPU != i*86 && $CPU != arm* ]] && TS_MAYBE_QEMU=1

# Timeout for tsp commands in tests.
[[ -z $TS_MAYBE_QEMU ]] && export TSP_TIMEOUT=180s || export TSP_TIMEOUT=1800s

# Display help text
showhelp()
{
    cat >&2 <<EOF

Usage: $SCRIPT [options]

Common test options:

  --args "..."
      Pass additional test-specific arguments to the test script.

  --bin directory
      Use development versions of TSDuck as compiled in the Git repository in
      the specified directory.

  --dev
      Use development versions of TSDuck as compiled in the Git repository in
      $TSDUCKBIN_RELEASE

  --dev32
      Use development versions of TSDuck as compiled in the Git repository in
      $TSDUCKBIN32_RELEASE

  --debug
      Use debug versions of TSDuck as compiled in the Git repository in
      $TSDUCKBIN_DEBUG

  --debug32
      Use debug versions of TSDuck as compiled in the Git repository in
      $TSDUCKBIN32_DEBUG

  --help
      Display this help text.

  --init
      Create initial reference output files. This should be done at least once
      for each test. The reference files must be checked manually to ensure
      that they are correct. They will be later used as reference for the test.

  -v
  --verbose
      Display verbose information.

EOF
    exit $EXIT_FAILURE
}

# Decode command line options.
while [[ $# -gt 0 ]]; do
    case "$1" in
        --args)
            [[ $# -gt 1 ]] || usage; shift
            ARGS="$1"
            ;;
        --bin)
            [[ $# -gt 1 ]] || usage; shift
            DEVEL=true
            TSDUCKBIN="$1"
            ;;
        --dev)
            DEVEL=true
            TSDUCKBIN=$TSDUCKBIN_RELEASE
            ;;
        --dev32)
            DEVEL=true
            TSDUCKBIN=$TSDUCKBIN32_RELEASE
            $SYS64 && NATIVE=false
            OS2=$OS-32
            ;;
        --debug)
            DEVEL=true
            TSDUCKBIN=$TSDUCKBIN_DEBUG
            ;;
        --debug32)
            DEVEL=true
            TSDUCKBIN=$TSDUCKBIN32_DEBUG
            $SYS64 && NATIVE=false
            OS2=$OS-32
            ;;
        --help)
            showhelp
            ;;
        --init*)
            TESTINIT=true
            ;;
        -v|--verbose)
            VERBOSE=true
            ;;
        *)
            usage
            ;;
    esac
    shift
done

# Replace command line arguments for the test script.
set -- $ARGS

# Make sure the temporary directory (for test output) exists.
mkdir -p "$TMPDIR"

# Locate the TSDuck executables
if $DEVEL; then
    # Development mode, check that the bin directory exists.
    [[ -d "$TSDUCKBIN" ]] || error "not found: $TSDUCKBIN"

    # Build the path for a TSDuck command.
    tspath() { echo "$TSDUCKBIN/$1$EXE"; }
else
    # Build the path for a TSDuck command (use the installed product).
    tspath() { echo "$1$EXE"; }
fi

# Build the native path of a file, required for TSDuck command line arguments.
if $WINDOWS; then
    fpath() { cygpath -w "$1"; }
else
    fpath() { echo "$1"; }
fi

# Define clean paths, from scratch.
if $DEVEL; then
    case $OS in
        windows)
            export PATH=$(fpath "$TSDUCKBIN")";$PATH"
            export TSPLUGINS_PATH=$(fpath "$TSDUCKBIN")
            export PYTHONPATH=$(fpath "$TSDUCKDIR/src/libtsduck/python")
            export TSDUCKJAR="$TSDUCKBIN_ROOT/java/tsduck.jar"
            export CLASSPATH=$(fpath "$TSDUCKJAR")";"
            ;;
        *)
            export PATH="$TSDUCK:$PATH"
            export TSPLUGINS_PATH="$TSDUCKBIN"
            export LD_LIBRARY_PATH="$TSDUCKBIN"
            export LD_LIBRARY_PATH2="$TSDUCKBIN"
            export PYTHONPATH="$TSDUCKDIR/src/libtsduck/python"
            export TSDUCKJAR="$TSDUCKBIN/tsduck.jar"
            export CLASSPATH="$TSDUCKJAR:"
            ;;
    esac
else
    case $OS in
        windows)
            export PYTHONPATH=$(fpath "$TSDUCK/python")
            export TSDUCKJAR=$(fpath "$TSDUCK/java/tsduck.jar")
            export CLASSPATH="$TSDUCKJAR;"
            ;;
        mac)
            export PYTHONPATH=$BREWPREFIX/share/tsduck/python
            export TSDUCKJAR=$BREWPREFIX/share/tsduck/java/tsduck.jar
            export CLASSPATH="$TSDUCKJAR:"
            ;;
        freebsd|openbsd|dragonfly)
            export PYTHONPATH=/usr/local/share/tsduck/python
            export TSDUCKJAR=/usr/local/share/tsduck/java/tsduck.jar
            export CLASSPATH="$TSDUCKJAR:"
            ;;
        netbsd)
            export PYTHONPATH=/usr/pkg/share/tsduck/python
            export TSDUCKJAR=/usr/pkg/share/tsduck/java/tsduck.jar
            export CLASSPATH="$TSDUCKJAR:"
            ;;
        *)
            export PYTHONPATH=/usr/share/tsduck/python
            export TSDUCKJAR=/usr/share/tsduck/java/tsduck.jar
            export CLASSPATH="$TSDUCKJAR:"
            ;;
    esac
fi

# Python and Java commands.
case $OS in
    windows)
        PYTHON=python
        JAVA=java
        JAVAC=javac
        JAVAP=javap
        JAR=jar
        ;;
    *)
        PYTHON=$(which python3 2>/dev/null)
        JAVA=$("$TSDUCKDIR/scripts/java-config.sh" --java)
        JAVAC=$("$TSDUCKDIR/scripts/java-config.sh" --javac)
        JAVAP=$("$TSDUCKDIR/scripts/java-config.sh" --bin)/javap
        JAR=$("$TSDUCKDIR/scripts/java-config.sh" --jar)
        [[ -z "$PYTHON" ]] && PYTHON=python
        [[ -z "$JAVA" ]] && JAVA=java
        [[ -z "$JAVAC" ]] && JAVA=javac
        [[ -z "$JAVAP" ]] && JAVA=javap
        [[ -z "$JAR" ]] && JAR=jar
        ;;
esac

# Disable loading extensions to avoid locally installed extensions generating different logs.
export TSLIBEXT_NONE=true

# Do not check new versions.
export TSDUCK_NO_VERSION_CHECK=true

# Prevent using the user's configuration file to avoid non-standard defaults.
export TSDUCK_NO_USER_CONFIG=true

# Enforce some retries on test downloads from tsduck.io (hosting issues?)
export TS_CURL_RETRY="RETRY=5,INTERVAL=100,HOST=tsduck.io"

# Number of lines in a file.
linecount() { wc -l "$1" | awk '{print $1}'; }

# The reference directory must be created at first --init.
$TESTINIT && mkdir -p "$REFDIR"

# The output files are created in the reference area with --init.
$TESTINIT && OUTDIR="$REFDIR" || OUTDIR="$TMPDIR"

# Log a test success or failure.
PASSED="$TMPDIR/.passed"
FAILED="$TMPDIR/.failed"
pass() { info "$PRPASS  $SCRIPT: $*"; echo "$SCRIPT: $*" >>$PASSED; }
fail() { info "$PRFAIL  $SCRIPT: $*"; echo "$SCRIPT: $*" >>$FAILED; }

# Check if an argument matches a string. Print "true" or "false".
# Syntax: test_arg string args....
test_arg() {
    local test="$1"
    local arg
    shift
    for arg in "$@"; do
        if [[ "$arg" == "$test" ]]; then
            echo true
            return 0
        fi
    done
    echo false
    return 1
}

# Initializes a test run, reset passed and failed tests.
test_start() {
    rm -f "$PASSED" "$FAILED"
    touch "$PASSED" "$FAILED"
}

# Exit test script, report failed or passed tests.
test_exit() {
    NPASSED=$(linecount "$PASSED")
    NFAILED=$(linecount "$FAILED")
    if $TESTINIT; then
        info "$PRPASS  Tests initialization completed"
    elif [[ $NFAILED -eq 0 ]]; then
        info "$PRPASS  ALL $NPASSED tests passed"
    else
        info "$PRFAIL  $NFAILED tests FAILED, $NPASSED tests passed, review failed tests in $FAILED"
    fi
    exit $NFAILED
}

# Abort current test if not testing a native binary.
# Useful to avoid testing a Win32 DLL with a native 64-bit Java or Python executable.
native_only() {
    if ! $NATIVE; then
        pass "skipped on non-native binary"
        exit $EXIT_SUCCESS
    fi
}

# Abort current test if testing on asan (address sanitizer) build.
# Useful to skip java/python tests and tests which use libraries with memory leaks and other issues.
exclude_on_asan() {
    if [[ -n "$ASAN_RUN" ]]; then
        pass "skipped on address sanitizer build"
        exit $EXIT_SUCCESS
    fi
}

# Get the list of output files matching a wildcard.
# Syntax: test_outputs test-file-wildcard
test_outputs() {
    if [[ -n "$1" ]]; then
        local grepopts=
        for os in $OTHEROS; do grepopts="$grepopts -e .$os."; done
        ls -1 -d 2>/dev/null "$OUTDIR"/$1 | grep -F -v $grepopts
    fi
}

# Cleanup temporary output file matching a wildcard.
# Syntax: test_cleanup test-file-wildcard
test_cleanup() {
    rm -rf $(test_outputs "$1")
}

# Check a temporary text file in 'tmp' against a reference file in 'reference'.
# Do nothing with --init since we are creating the reference files.
# Syntax: test_text test-file [-s]
# Option: -s: silent in case of success
test_text() {
    local file=$1
    local silent=$(test_arg -s "$@")

    # Remove all reference to $INDIR, $OUTDIR and $TMPDIR in case this is a log file.
    local in=$(fpath "$INDIR" | sed -e 's|\\|\\\\|g' )
    local out=$(fpath "$OUTDIR" | sed -e 's|\\|\\\\|g' )
    local tmp=$(fpath "$TMPDIR" | sed -e 's|\\|\\\\|g' )
    sed -i -e "s|$in[/\\\\]*||g" -e "s|$out[/\\\\]*||g" -e "s|$tmp[/\\\\]*||g" "$OUTDIR/$file"

    if [[ $OS == windows ]]; then
        in=$(fpath "$INDIR" | sed -e 's|\\|\\\\\\\\|g' )
        out=$(fpath "$OUTDIR" | sed -e 's|\\|\\\\\\\\|g' )
        tmp=$(fpath "$TMPDIR" | sed -e 's|\\|\\\\\\\\|g' )
        sed -i -e "s|$in[/\\\\]*||g" -e "s|$out[/\\\\]*||g" -e "s|$tmp[/\\\\]*||g" "$OUTDIR/$file"
    fi

    # Do not compare if this is test initialization.
    $TESTINIT && return 0

    # The diff options are limited on OpenBSD, the comparison is less strict.
    local opt="--strip-trailing-cr"
    [[ $OS == openbsd ]] && opt="-b"

    # Compare the files.
    if [[ ! -r "$REFDIR/$file" ]]; then
        fail "Reference output $REFDIR/$file missing"
        return 1
    elif diff $opt "$REFDIR/$file" "$TMPDIR/$file" &>$TMPDIR/$file.diff; then
        rm -f "$TMPDIR/$file.diff"
        $silent || pass "Test $file passed"
        return 0
    else
        fail "Test $file FAILED, check $TMPDIR/$file.diff"
        return 1
    fi
}

# Check a temporary binary file in 'tmp' against a reference file in 'reference'.
# Do nothing with --init since we are creating the reference files.
# Syntax: test_bin test-file [-s]
# Option: -s: silent in case of success
test_bin() {
    local file=$1
    local silent=$(test_arg -s "$@")

    # Do not compare if this is test initialization.
    $TESTINIT && return 0

    # Compare the files.
    if [[ ! -r "$REFDIR/$file" ]]; then
        fail "Reference output $REFDIR/$file missing"
        return 1
    elif cmp "$REFDIR/$file" "$TMPDIR/$file" &>$TMPDIR/$file.diff; then
        rm -f "$TMPDIR/$file.diff"
        $silent || pass "Test $file passed"
        return 0
    else
        [[ $(linecount "$TMPDIR/$file.diff") -eq 1 ]] && details=$(cat "$TMPDIR/$file.diff") || details="see $TMPDIR/$file.diff"
        fail "Test $file FAILED, $details"
        return 1
    fi
}

# Get the size of a file in bytes.
file_size() {
    [[ $OS == mac || $OS == freebsd || $OS == netbsd || $OS == openbsd || $OS == dragonfly ]] && stat -f %z "$@" || stat -c %s "$@"
}

# The syntax of dos2unix depends on the system.
dos_to_unix() {
    [[ $OS == freebsd || $OS == dragonfly ]] && dos2unix "$@" || dos2unix -q "$@"
}

# A tsp command with all standard options to get a deterministic output.
# We also set a 3mn timeout, in case of hang or infinite loop.
test_tsp() {
    timeout -s9 $TSP_TIMEOUT $(tspath tsp) --synchronous-log --bitrate-adjust-interval 10,000 "$@"
}
