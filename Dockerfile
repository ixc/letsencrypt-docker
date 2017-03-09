FROM alpine:3.5

RUN apk update \
    && apk upgrade \
    && apk add \
        bash \
        certbot \
        nginx \
        py-pip \
        tini \
    && rm -rf /var/cache/apk/*

RUN pip install --no-cache-dir docker-compose python-dockercloud

RUN ln -s /opt/letsencrypt/bin/certbot.sh /etc/periodic/daily/

ENV PATH="/opt/letsencrypt/bin:$PATH"

EXPOSE 80
VOLUME /etc/letsencrypt

ENTRYPOINT ["tini", "--", "entrypoint.sh"]
CMD ["run.sh"]

COPY . /opt/letsencrypt/
