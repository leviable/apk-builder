ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}

LABEL org.opencontainers.image.source https://github.com/leviable/apk-builder

WORKDIR /apk-builder

RUN apk add --no-cache alpine-sdk sudo abuild && \
    rm -rf /var/cache/apk/*

RUN sed -i "s/^\#PACKAGER.*$/PACKAGER=apk-builder/" /etc/abuild.conf && \
    sed -i "/^\#MAINTAINER.*$/s/^#//" /etc/abuild.conf && \
    sed -e 's/^wheel:\(.*\)/wheel:\1,hiroom2/g' -i /etc/group



ARG user=builder
ARG home=/home/$user
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home $home \
    --ingroup abuild \
    $user && \
    addgroup builder wheel

RUN mkdir -p /var/cache/distfiles && \
    chgrp abuild /var/cache/distfiles && \
    chmod g+w /var/cache/distfiles


RUN chgrp abuild /apk-builder && \
    chown builder /apk-builder

USER builder

CMD ["ash"]
