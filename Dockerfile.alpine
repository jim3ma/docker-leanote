FROM alpine:3.5

ENV LEANOTE_VERSION=2.2.1

RUN apk add --no-cache --update wget ca-certificates \
    && wget https://iweb.dl.sourceforge.net/project/leanote-bin/2.2.1/leanote-linux-amd64-v${LEANOTE_VERSION}.bin.tar.gz \
    && tar -zxvf leanote-linux-amd64-v${LEANOTE_VERSION}.bin.tar.gz -C / \
    && mkdir -p /leanote/data/public/upload \
    && mkdir -p /leanote/data/files \
    && mkdir -p /leanote/data/mongodb_backup \
    && rm -r /leanote/public/upload \
    && rm -r /leanote/mongodb_backup \
    && rm leanote-linux-amd64-v${LEANOTE_VERSION}.bin.tar.gz \
    && ln -s /leanote/data/public/upload /leanote/public/upload \
    && ln -s /leanote/data/files /leanote/files \
    && ln -s /leanote/data/mongodb_backup /leanote/mongodb_backup

RUN echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing/' >> /etc/apk/repositories \
    && apk add --no-cache --update mongodb-tools@testing

VOLUME /leanote/data/

EXPOSE 9000

CMD ["sh", "/leanote/bin/run.sh"]
