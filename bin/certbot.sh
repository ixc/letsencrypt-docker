#!/bin/bash

set -e

# Load environment variables set by Docker
if [ -e /opt/letsencrypt/etc/global.env ]; then
	. /opt/letsencrypt/etc/global.env
fi

mkdir -p /opt/www

# Certificates are separated by semi-colon (;) or newline. Domains on each
# certificate are separated by comma (,).
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
			$OPTIONS; then # || true  # Don't exit if a single certificate fails
		if [[ -z "$DEFAULT" ]]; then
			DEFAULT="$(echo "$DOMAINS" | cut -d',' -f1)"
			echo "Found first successful certificate to use as default: $DEFAULT"
		fi
	fi
done

# Combine private key and full certificate chain for HAproxy.
if [[ -d /etc/letsencrypt/live ]]; then
	cd /etc/letsencrypt/live
	for domain in *; do
		cat "$domain/privkey.pem" "$domain/fullchain.pem" > "/certs/$domain.pem"
		if [[ "$domain" = "$DEFAULT" ]]; then
			echo "Saving default certificate ($domain) as '_default.pem'."
			cp "/certs/$domain.pem" /certs/_default.pem
		fi
	done

	# Reload HAproxy.
	if [[ -n "${HAPROXY_RELOAD_LABEL+1}" ]]; then
		for container in $(docker ps -f label="$HAPROXY_RELOAD_LABEL" -q); do
			echo "Reloading HAproxy container: $container"
			docker exec "$container" /reload.sh
		done
	fi
fi
