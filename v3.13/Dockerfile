ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache alpine-sdk sudo abuild && \
    rm -rf /var/cache/apk/*

RUN sed -i "s/^\#PACKAGER.*$/PACKAGER=apk-builder/" /etc/abuild.conf && \
    sed -i "/^\#MAINTAINER.*$/s/^#//" /etc/abuild.conf


ARG user=builder
ARG home=/home/$user
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home $home \
    --ingroup abuild \
    $user

RUN mkdir -p /var/cache/distfiles && \
    chgrp abuild /var/cache/distfiles && \
    chmod g+w /var/cache/distfiles


USER builder

WORKDIR /apk-builder

CMD ["ash"]
