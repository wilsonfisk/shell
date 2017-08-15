#!/usr/bin/env bash
# jwt-decver.sh - decode and verify a JWT (JSON Web Token)
# source: http://willhaley.com/blog/generate-jwt-with-bash/
# Requirements: jq and openssl installed for this to work.
# Edit SECRET as needed to verify the JWT is properly signed.
set -euo pipefail
IFS=$'\n\t'

SECRET='SOME SECRET'

function base64_encode()
{
    declare INPUT=${1:-$(</dev/stdin)}
    echo -n "${INPUT}" | openssl enc -base64 -A
}

function base64_decode()
{
    declare INPUT=${1:-$(</dev/stdin)}
    echo -n "${INPUT}" | openssl enc -base64 -d -A
}

function verify_signature()
{
    declare HEADER_AND_PAYLOAD=${1}
    EXPECTED=$(echo "${HEADER_AND_PAYLOAD}" | hmacsha256_encode | base64_encode)
    ACTUAL=${2}

    if [ "${EXPECTED}" == "${ACTUAL}" ]
    then
        echo "Signature is valid"
    else
        echo "Signature is NOT valid"
    fi
}

function hmacsha256_encode()
{
    declare INPUT=${1:-$(</dev/stdin)}
    echo -n "${INPUT}" | openssl dgst -binary -sha256 -hmac "${SECRET}"
}

# Read the token from stdin
declare TOKEN=${1:-$(</dev/stdin)};

IFS='.' read -ra PIECES <<< "$TOKEN"

declare HEADER=${PIECES[0]}
declare PAYLOAD=${PIECES[1]}
declare SIGNATURE=${PIECES[2]}

echo "Header"
echo "${HEADER}" | base64_decode | jq
echo "Payload"
echo "${PAYLOAD}" | base64_decode | jq

verify_signature "${HEADER}.${PAYLOAD}" "${SIGNATURE}"
