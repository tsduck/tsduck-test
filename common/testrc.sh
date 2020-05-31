#!/bin/bash
# ------------------------------------------------------------------------------
# This file shall be source'd by all test scripts.
# It parses the common command line options and defines variables and functions.
# ------------------------------------------------------------------------------

# Build script name from caller's name.
SCRIPT=$(basename ${BASH_SOURCE[1]} .sh)
SCRIPTDIR=$(cd $(dirname ${BASH_SOURCE[1]}); pwd)

# Root directory of test repository and subdirs.
COMMONDIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)
ROOTDIR=$(cd "$COMMONDIR/.."; pwd)
TESTSDIR="$ROOTDIR/tests"
INDIR="$ROOTDIR/input"
REFDIR="$ROOTDIR/reference"
TMPDIR="$ROOTDIR/tmp"

# Root directory of TSDuck repository, supposed to be cloned at same level.
TSDUCKDIR=$(cd "$ROOTDIR/.."; pwd)/tsduck

# Default values for command line options.
DEVEL=false
TESTINIT=false
VERBOSE=false

# Output line prefixes.
PRPASS="----"
PRFAIL="XXXX"
PRVOID="    "

# Functions to report messages.
error() { echo >&2 "$SCRIPT: $*"; exit 1; }
info()  { echo >&2 "$*"; }
trace() { $VERBOSE && info "$PRVOID  $*"; }
usage() { echo >&2 "invalid command, try \"$SCRIPT --help\""; exit 1; }

# Use GNU variants of sed and grep when available.
[[ -n "$(which gsed 2>/dev/null)" ]] && sed() { gsed "$@"; }
[[ -n "$(which ggrep 2>/dev/null)" ]] && grep() { ggrep "$@"; }

# Prefix of a file path (remove extension).
prefix() { sed -e 's/\.[^\.]*$//' <<<$1; }

# Operating system.
OS=$(uname -s | tr A-Z a-z)

case $OS in
    cygwin*|msys*|mingw*)
        OS=windows
        ;;
    darwin)
        OS=mac
        ;;
esac

# All operating systems and "other" operating systems.
ALLOS="linux mac windows"
OTHEROS=${ALLOS/$OS/}

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
    ARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/^arm.*$/arm/')
    TSDUCKBIN_ROOT=$TSDUCKDIR/src/tstools
    TSDUCKBIN_RELEASE=$($TSDUCKDIR/build/setenv.sh --display)
    TSDUCKBIN_DEBUG=$($TSDUCKDIR/build/setenv.sh --display --debug)
    TSDUCKBIN32_RELEASE=${TSDUCKBIN_RELEASE/x86_64/i386}
    TSDUCKBIN32_DEBUG=${TSDUCKBIN_DEBUG/x86_64/i386}
    EXE=
fi

# Display help text
showhelp()
{
    cat >&2 <<EOF

Usage: $SCRIPT [options]

Common test options:

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
    exit 1
}

# Decode command line options.
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dev)
            DEVEL=true
            TSDUCKBIN=$TSDUCKBIN_RELEASE
            ;;
        --dev32)
            DEVEL=true
            TSDUCKBIN=$TSDUCKBIN32_RELEASE
            ;;
        --debug)
            DEVEL=true
            TSDUCKBIN=$TSDUCKBIN_DEBUG
            ;;
        --debug32)
            DEVEL=true
            TSDUCKBIN=$TSDUCKBIN32_DEBUG
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

# Command prefix on macOS.
CMDPREFIX=
[[ $OS == mac && -n "$LD_LIBRARY_PATH" ]] && CMDPREFIX="LD_LIBRARY_PATH=$LD_LIBRARY_PATH "

# Number of lines in a file.
linecount() { wc -l "$1" | awk '{print $1}'; }

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

# Cleanup temporary output file matching a wildcard.
# Syntax: test_cleanup test-file-wildcard
test_cleanup() {
    if [[ -n "$1" ]]; then
        local grepopts=
        for os in $OTHEROS; do grepopts="$grepopts -e .$os."; done
        rm -rf $(ls -d 2>/dev/null "$OUTDIR"/$1 | fgrep -v $grepopts)
    fi
}

# Check a temporary text file in 'tmp' against a reference file in 'reference'.
# Do nothing with --init since we are creating the reference files.
# Syntax: test_text test-file [-s]
# Option: -s: silent in case of success
test_text() {
    local file=$1
    local silent=$(test_arg -s "$@")

    # Remove all reference to $INDIR and $OUTDIR in case this is a log file.
    in=$(fpath "$INDIR" | sed -e 's|\\|\\\\|g' )
    out=$(fpath "$OUTDIR" | sed -e 's|\\|\\\\|g' )
    sed -i -e "s|$in[/\\\\]*||g" -e "s|$out[/\\\\]*||g" "$OUTDIR/$file"

    # Do not compare if this is test initialization.
    $TESTINIT && return 0

    # Compare the files.
    if [[ ! -r "$REFDIR/$file" ]]; then
        fail "Reference output $REFDIR/$file missing"
        return 1
    elif diff --strip-trailing-cr "$REFDIR/$file" "$TMPDIR/$file" >$TMPDIR/$file.diff; then
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
    elif cmp "$REFDIR/$file" "$TMPDIR/$file" >$TMPDIR/$file.diff; then
        rm -f "$TMPDIR/$file.diff"
        $silent || pass "Test $file passed"
        return 0
    else
        [[ $(linecount "$TMPDIR/$file.diff") -eq 1 ]] && details=$(cat "$TMPDIR/$file.diff") || details="see $TMPDIR/$file.diff"
        fail "Test $file FAILED, $details"
        return 1
    fi
}
