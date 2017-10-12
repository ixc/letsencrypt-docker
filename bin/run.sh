#!/bin/bash

set -e

# So Docker variables can be loaded when running from cron
export -p > /opt/letsencrypt/etc/global.env

nginx.sh
certbot.sh || true # Don't exit on failure on initial start to avoid triggering rate limits
crond -f
