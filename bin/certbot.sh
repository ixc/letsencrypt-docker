#!/bin/bash

set -e

mkdir -p /opt/www

# Certificates are separated by semi-colon (;). Domains on each certificate are
# separated by comma (,).
CERTS=(${DOMAINS//;/ })

# Create or renew certificates.
for DOMAINS in "${CERTS[@]}"; do
	if certbot certonly \
			--agree-tos \
			--domains "$DOMAINS" \
			--email "$EMAIL" \
			--expand \
			--noninteractive \
			--webroot \
			--webroot-path /opt/www \
			$OPTIONS; then
		UPDATED=1
	fi
done

# Combine private key and full certificate chain for HAproxy and restart.
if [[ -n "${UPDATED+1}" ]]; then
	cd /etc/letsencrypt/live
	mkdir -p /etc/letsencrypt/haproxy
	for domain in *; do
		cat "$domain/privkey.pem" "$domain/fullchain.pem" > "/etc/letsencrypt/haproxy/$domain.pem"
	done
	for container in $(docker ps -f status=running -f volume=/etc/letsencrypt -q); do
		docker exec "$container" /reload.sh
	done
fi
