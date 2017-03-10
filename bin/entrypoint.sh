#!/bin/bash

set -e

for var in DOMAINS EMAIL; do
    eval [[ -z \${$var+1} ]] && {
        >&2 echo "ERROR: Missing required environment variable: $var"
        exit 1
    }
done

VERSION=$(docker version 2>&1 >/dev/null | grep 'Error response from daemon: client is newer than server')
if [[ -n "$VERSION" ]]; then
	VERSION="${VERSION#*server API version: }"
	VERSION="${VERSION%)*}"
	export DOCKER_API_VERSION="$VERSION"
fi

exec "${@:-bash}"
