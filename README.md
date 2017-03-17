# Overview

The `interaction/letsencrypt` image will:

  * Automatically create or renew certificates on startup and daily thereafter.

  * Optionally combine private keys and their full certificate chain for
    HAproxy and restart.

# Usage

In your `letsencrypt` service:

  * Define a `DOMAINS` environment variable. Certificates are separated by
    semi-colon (;) and domains are separated by comma (,).

  * Define an `EMAIL` environment variable. It will be used for all
    certificates.

  * Define an `OPTIONS` environment variable, if you want to pass additional
    arguments to `certbot` (e.g. `--staging`).

If using with HAproxy:

  * Add `volumes_from: letsencrypt` to your `haproxy` service.

  * Define a `CERT_FOLDER=/etc/letsencrypt/haproxy` environment variable in
    your `haproxy` service.

  * Define an `HAPROXY_IMAGE=dockercloud/haproxy:1.6.3` environment variable in
  	your `letsencrypt` service.

Sample compose and stack files are provided.
