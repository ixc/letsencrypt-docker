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
if [[ -n "${UPDATED+1}" && -n "$HAPROXY_CONTAINER_NAME" ]]; then
	for domain in *; do
		cat "/etc/letsencrypt/live/$domain/privkey.pem" "/etc/letsencrypt/live/$domain/fullchain.pem" > "/etc/letsencrypt/haproxy/$domain.pem"
	done
	docker exec $(docker ps -f name="$HAPROXY_CONTAINER_NAME" -q) /reload.sh
fi
