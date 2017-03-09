#!/bin/bash

set -e

nginx.sh
certbot.sh
crond -f
