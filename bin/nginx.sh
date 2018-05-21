#!/bin/bash

set -e

mkdir -p /run/nginx

dockerize -template /opt/nginx/etc/nginx.tmpl.conf:/opt/nginx/etc/nginx.conf

exec nginx -c /opt/nginx/etc/nginx.conf "$@"
