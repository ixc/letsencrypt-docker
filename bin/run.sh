#!/bin/bash

set -e

nginx.sh
certbot.sh || true # Don't exit on failure on initial start to avoid triggering rate limits
crond -f
