FROM alpine:3.9

LABEL maintainer "Sven <sven@testthedocs.org>" \
    org.label-schema.vendor = "TestTheDocs"

ENV VALE_VERSION 1.3.2

COPY styles /srv/styles
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY vale.ini /srv/.vale.ini

RUN adduser -s /bin/false -D -H ttd \
    && apk --no-cache add \
    tini \
    su-exec \
    bash \
    && wget -O vale.tgz https://github.com/errata-ai/vale/releases/download/v${VALE_VERSION}/vale_${VALE_VERSION}_Linux_64-bit.tar.gz \
    && tar zxvf vale.tgz \
    && mv vale /usr/local/bin/vale \
    && rm LICENSE \
    && rm README.md

WORKDIR /srv
VOLUME /srv

#ENTRYPOINT [ "bash" ]
ENTRYPOINT [ "/sbin/tini", "--", "/usr/local/bin/entrypoint.sh" ]
