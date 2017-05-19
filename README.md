# Overview

The `interaction/letsencrypt` image will:

  * Automatically create or renew certificates on startup and daily thereafter.

  * Optionally combine private keys and their full certificate chain for
    HAproxy and restart.

# Usage

In your `letsencrypt` service:

  * Define a `DOMAINS` environment variable. Certificates are separated by
    newline or semi-colon (`;`) and domains are separated by comma (`,`).

    Note that Let's Encrypt has a limit of 20 certificates per registered
    domain per week, and 100 names per certificate. You should combine
    subdomains into a single certificat, wherever possible.

    See: https://letsencrypt.org/docs/rate-limits/

  * Define an `EMAIL` environment variable. It will be used for all
    certificates.

  * Define an `OPTIONS` environment variable, if you want to pass additional
    arguments to `certbot` (e.g. `--staging`).

  * Define an `NGINX_PROXY_PASS=1` environment variable, if you want to access
  	your sites over HTTP instead of redirecting to HTTPS. For example, if you
  	are unable to generate certificates because Let's Encrypt is down or your
  	account is rate limited.

If using with HAproxy:

  * Add `volumes_from: letsencrypt` to your `haproxy` service.

  * Define a `DEFAULT_SSL_CERT` environment variable to enable SSL termination.
    You can use a self signed certificate for this. It will only be used if no
    other certificates match.

        $ openssl req -x509 -newkey rsa:2048 -keyout cert0.pem -out cert0.pem -nodes -subj '/CN=*'

  * Define an `HAPROXY_IMAGE=dockercloud/haproxy:1.6.3` environment variable in
    your `letsencrypt` service.

Sample compose and stack files are provided, including a wildcard self signed
default certificate.
