#!/bin/bash

set -e

# Check for required environment variables.
for var in DOMAINS EMAIL; do
    eval [[ -z \${$var+1} ]] && {
        >&2 echo "ERROR: Missing required environment variable: $var"
        exit 1
    }
done

# Create required directory.
mkdir -p /etc/letsencrypt/haproxy

# Work around Docker API version mismatch.
VERSION=$(docker version 2>&1 >/dev/null | grep 'Error response from daemon: client is newer than server') || true  # Don't exit if grep fails
if [[ -n "$VERSION" ]]; then
	VERSION="${VERSION#*server API version: }"
	VERSION="${VERSION%)*}"
	export DOCKER_API_VERSION="$VERSION"
fi

# Convert newline separator to semi-colon for consistency.
export DOMAINS=${DOMAINS//'\n'/;}

exec "${@:-bash}"
