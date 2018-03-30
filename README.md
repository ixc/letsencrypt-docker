# Overview

The `interaction/letsencrypt` image will:

  * Redirect HTTP requests to HTTPS.

  * Automatically create or renew certificates on startup and daily thereafter.

  * Optionally combine private keys and their full certificate chain for
    HAproxy and restart it.

# Usage

In your `letsencrypt` service:

  * Define a `DOMAINS` environment variable. Certificates are separated by
    newline or semi-colon (`;`) and domains are separated by comma (`,`).

    **NOTE:** When used with HAproxy, the first domain for which a certificate
    is successfully generated will be used as the default (saved to
    `/certs/_default.pem`), overriding `DEFAULT_SSL_CERT`.

    **NOTE:** Let's Encrypt has a limit of 20 certificates per registered
    domain per week, and 100 names per certificate. You should combine
    subdomains into a single certificate, wherever possible.

    See: https://letsencrypt.org/docs/rate-limits/

  * Define an `EMAIL` environment variable. It will be used for registration
    and expiration emails for all certificates.

  * Define an `OPTIONS` environment variable, if you want to pass additional
    arguments to `certbot` (e.g. `--staging`).

If using with [dockercloud-haproxy](https://github.com/docker/dockercloud-haproxy):

  * Mount a named volume at `/certs` in both services.

  * Define a `DEFAULT_SSL_CERT` environment variable to enable SSL termination.
    You can use a self signed certificate for this. It will only be used if no
    other certificates match.

        $ openssl req -x509 -newkey rsa:2048 -keyout cert0.pem -out cert0.pem -nodes -subj '/CN=*'

  * Add a `com.ixc.letsencrypt.haproxy-reload` label to your `haproxy` service,
    and an `HAPROXY_RELOAD_LABEL=com.ixc.letsencrypt.haproxy-reload`
    environment variable to your `letsencrypt` service.

    **NOTE:** You can use a different label, it just needs to be the same for
    both services.

Sample compose and stack files are provided, including a wildcard self signed
default certificate.
