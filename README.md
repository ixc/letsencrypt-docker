# Overview

An nginx service to be deployed alongside `acmi.sh`.

Provides:

- HTTP to HTTPS redirects.
- Web server (nginx) for HTTP-01 challenge requests via `acme.sh -w /opt/nginx/www`.

Assumes:

- DNS Made Easy is used for DNS-01 challenges. If not, update the `ME_*` environment variables and `--dns dns_me` command line argument, per https://github.com/Neilpang/acme.sh/blob/master/dnsapi/README.md
- https://github.com/docker/dockercloud-haproxy is used for SSL termination. If not, update the `DEPLOY_HAPROXY_*` environment variables and `--deploy-hook haproxy` command line argument, per https://github.com/Neilpang/acme.sh/blob/master/deploy/README.md
- Deployed to Docker for AWS with persistent shared CloudStor volumes. If not, update the `volumes` section in `docker-compose.yml`.

Check the included `docker-compose.yml` for usage.
