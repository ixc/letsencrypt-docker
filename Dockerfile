FROM alpine:3.5

RUN apk update \
    && apk upgrade \
    && apk add \
        bash \
        ca-certificates \
        certbot \
        docker \
        nginx \
        tini \
        wget \
    && rm -rf /var/cache/apk/*

RUN update-ca-certificates

ENV DOCKERIZE_VERSION=0.4.0
RUN wget -nv -O - "https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz" | tar -xz -C /usr/local/bin/ -f -

RUN ln -s /opt/letsencrypt/bin/certbot.sh /etc/periodic/daily/certbot

ENV PATH="/opt/letsencrypt/bin:$PATH"

EXPOSE 80

VOLUME /certs
VOLUME /etc/letsencrypt

ENTRYPOINT ["/sbin/tini", "--", "entrypoint.sh"]
CMD ["run.sh"]

COPY . /opt/letsencrypt/
