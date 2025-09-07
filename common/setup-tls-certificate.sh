#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# This file shall be source'd by test scripts which need a TLS certificate.
# The certificate is created if it does not already exist.
# The required environment variables for use with TSDuck are defined.
# ------------------------------------------------------------------------------


if [[ $OS != windows ]]; then

    # Handle a special case on GiHub macOS runners.
    if [[ $OS == mac ]]; then
        # On 2025, with runner macos-latest, identified as "macos-14-arm64 Version: 20250818.1747",
        # Homebrew provides openssl@3. However, for some weird reasons, "/opt/homebrew/bin/openssl version"
        # displays "OpenSSL 1.1.1w  11 Sep 2023". OpenSSL commands fail because of parameters which are not
        # supported in 1.1. Trying to "brew install openssl@3" fails because HomeBrew says it is already
        # installed. However, "brew reinstall openssl@3" correctly reinstalls OpenSSL 3.
        if openssl version | grep -qi 'OpenSSL 1'; then
            echo "=== Inconsistent OpenSSL version detected"
            echo "openssl command: $(which openssl)"
            echo "openssl version: $(openssl version)"
            ls -l $(which openssl)
            echo "reinstalling openssl@3"
            brew reinstall openssl@3
            echo "openssl command: $(which openssl)"
            echo "openssl version: $(openssl version)"
            ls -l $(which openssl)
        fi
    fi

    # On UNIX systems, certificates are created by OpenSSL.
    CERTFILE="$TMPDIR/test_cert.pem"
    KEYFILE="$TMPDIR/test_key.pem"

    # Create the certificate if it does not exist.
    # The command "openssl req" outputs a lot of garbage when creating the key.
    # The option -quiet suppresses it but it is not supported in older versions of openssl.
    # So, we remove it the hard way, trying to preserve potential error messages.
    # Additionally, CN names are limited to 64 characters in OpenSSL.
    if [[ ! -f "$CERTFILE" || ! -f "$KEYFILE" ]]; then
        openssl req -newkey rsa:3072 -new -noenc -x509 -subj="/CN=$(hostname | cut -c 1-62)" \
                -days 3650 -keyout "$KEYFILE" -out "$CERTFILE" \
                2>&1 | grep -v -e '\.\.\.\.' -e '^--*$'
    fi

    export TSDUCK_TLS_CERTIFICATE="$CERTFILE"
    export TSDUCK_TLS_KEY="$KEYFILE"

else

    # On Windows systems, we use a PowerShell command.
    # Create the certificate if it does not exist.
    if [[ -z $(powershell 'Get-ChildItem Cert:\CurrentUser\My | Where-Object -Property FriendlyName -eq "test_key"') ]]; then
        powershell '[void](New-SelfSignedCertificate -FriendlyName "test_key" -Type SSLServerAuthentication -DnsName @([System.Net.Dns]::GetHostName(), "localhost") -CertStoreLocation Cert:\CurrentUser\My -KeyAlgorithm "RSA" -KeyLength 3072 -NotAfter ((Get-Date).AddYears(10)))'
    fi

    export TSDUCK_TLS_CERTIFICATE="test_key"
    export TSDUCK_TLS_STORE="user"

fi
