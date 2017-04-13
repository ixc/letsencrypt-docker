FROM alpine:3.5

RUN apk update \
    && apk upgrade \
    && apk add \
        bash \
        certbot \
        docker \
        nginx \
        tini \
    && rm -rf /var/cache/apk/*

RUN ln -s /opt/letsencrypt/bin/certbot.sh /etc/periodic/daily/

ENV PATH="/opt/letsencrypt/bin:$PATH"

EXPOSE 80

VOLUME /certs
VOLUME /etc/letsencrypt

ENTRYPOINT ["tini", "--", "entrypoint.sh"]
CMD ["run.sh"]

COPY . /opt/letsencrypt/
