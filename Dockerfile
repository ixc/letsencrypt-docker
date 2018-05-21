FROM alpine:3.7

RUN apk update \
    && apk upgrade \
    && apk add \
        bash \
        curl \
        nginx \
        tini \
        wget \
    && rm -rf /var/cache/apk/*

ENV DOCKERIZE_VERSION=0.6.1
RUN wget -nv -O - "https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz" | tar -xz -C /usr/local/bin/ -f -

ENV PATH="/opt/nginx/bin:$PATH"

EXPOSE 80

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["nginx.sh"]

COPY . /opt/nginx/
