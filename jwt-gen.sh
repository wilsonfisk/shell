#!/usr/bin/env bash
# jwt-gen.sh - Generate JWT (JSON Web Token)
# source: http://willhaley.com/blog/generate-jwt-with-bash/
# Requirements: jq and openssl installed for this to work.
# Edit the SECRET, HEADER, and PAYLOAD as needed.
# This will only generate JWTs with HMAC signing using SHA256, a.k.a. HS256 and HMACSHA256.
# The JWT Debugger [ https://jwt.io/ ] can be used to verify the string is valid & properly signed.
set -euo pipefail
IFS=$'\n\t'

SECRET='SOME SECRET'
HEADER='{
    "typ": "JWT",
    "alg": "HS256",
    "kid": "0001",
    "iss": "Bash JWT Generator",
    "exp": '$(($(date +%s)+1))',
    "iat": '$(date +%s)'
}'
PAYLOAD='{
    "Id": 1,
    "Name": "Hello, world!"
}'

function base64_encode()
{
    declare INPUT=${1:-$(</dev/stdin)}
    echo -n "${INPUT}" | openssl enc -base64 -A
}

# For some reason, probably bash-related, JSON that terminates with an integer
# must be compacted. So it must be something like `{"userId":1}` or else the
# signing gets screwed up. Weird, but using `jq -c` works to fix that.
function json() {
    declare INPUT=${1:-$(</dev/stdin)}
    echo -n "${INPUT}" | jq -c .
}

function hmacsha256_sign()
{
    declare INPUT=${1:-$(</dev/stdin)}
    echo -n "${INPUT}" | openssl dgst -binary -sha256 -hmac "${SECRET}"
}

HEADER_BASE64=$(echo "${HEADER}" | json | base64_encode)
PAYLOAD_BASE64=$(echo "${PAYLOAD}" | json | base64_encode)

HEADER_PAYLOAD=$(echo "${HEADER_BASE64}.${PAYLOAD_BASE64}")
SIGNATURE=$(echo "${HEADER_PAYLOAD}" | hmacsha256_sign | base64_encode)

echo "${HEADER_PAYLOAD}.${SIGNATURE}"
