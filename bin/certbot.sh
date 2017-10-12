#!/bin/bash

set -e

# Load environment variables set by Docker
if [ -e /opt/letsencrypt/global.env ]; then
	. /opt/letsencrypt/global.env
fi

mkdir -p /opt/www

# Certificates are separated by semi-colon (;). Domains on each certificate are
# separated by comma (,).
CERTS=(${DOMAINS//;/ })

# Create or renew certificates.
for DOMAINS in "${CERTS[@]}"; do
	certbot certonly \
		--agree-tos \
		--domains "$DOMAINS" \
		--email "$EMAIL" \
		--expand \
		--noninteractive \
		--webroot \
		--webroot-path /opt/www \
		$OPTIONS || true  # Don't exit if a single certificate fails
done

# Combine private key and full certificate chain for HAproxy.
cd /etc/letsencrypt/live
for domain in *; do
	cat "$domain/privkey.pem" "$domain/fullchain.pem" > "/certs/$domain.pem"
done

# Reload HAproxy.
if [[ -n "${HAPROXY_IMAGE+1}" ]]; then
	for container in $(docker ps -f ancestor="$HAPROXY_IMAGE" -f status=running -f volume=/etc/letsencrypt -q); do
		docker exec "$container" /reload.sh
	done
fi
