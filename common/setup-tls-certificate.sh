#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# This file shall be source'd by test scripts which need a TLS certificate.
# The certificate is created if it does not already exist.
# The required environment variables for use with TSDuck are defined.
# ------------------------------------------------------------------------------


if [[ $OS != windows ]]; then

    # On UNIX systems, certificates are created by OpenSSL.
    CERTFILE="$TMPDIR/test_cert.pem"
    KEYFILE="$TMPDIR/test_key.pem"

    # Create the certificate if it does not exist.
    if [[ ! -f "$CERTFILE" || ! -f "$KEYFILE" ]]; then
        openssl req -quiet -newkey rsa:3072 -new -noenc -x509 -subj="/CN=$(hostname)" \
                -days 3650 -keyout "$KEYFILE" -out "$CERTFILE"
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
