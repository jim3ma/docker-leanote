FROM golang:1.10-alpine as go-builder

ARG LEANOTE_VERSION=2.6.1
ARG LEANOTE_SOURCE=https://github.com/leanote/leanote.git

RUN echo build leanote ${LEANOTE_VERSION} from ${LEANOTE_SOURCE} \
    && apk add --no-cache --update git \
    && mkdir -p /go/src/github.com/leanote/ \
    && cd /go/src/github.com/leanote \
    && git clone -b ${LEANOTE_VERSION} ${LEANOTE_SOURCE} \
    && cd leanote \
    && go run app/cmd/main.go \
    && go build -o bin/leanote-linux-amd64 github.com/leanote/leanote/app/tmp

FROM node:9-alpine as node-builder

COPY --from=go-builder /go/src/github.com/leanote/leanote /go/src/github.com/leanote/leanote

RUN cd /go/src/github.com/leanote/leanote \
    && npm install \
    && npm install -g gulp \
    && npm install gulp-minify-css \
    && gulp

FROM alpine:3.7

COPY --from=go-builder /go/src/github.com/leanote/leanote/bin/leanote-linux-amd64 /leanote/bin/
COPY --from=go-builder /go/src/github.com/leanote/leanote/bin/run-linux-amd64.sh /leanote/bin/run.sh
COPY --from=go-builder /go/src/github.com/leanote/leanote/bin/src/ /leanote/bin/src/

COPY --from=node-builder /go/src/github.com/leanote/leanote/app/views /leanote/app/views
COPY --from=node-builder /go/src/github.com/leanote/leanote/conf /leanote/conf
COPY --from=node-builder /go/src/github.com/leanote/leanote/messages /leanote/messages
COPY --from=node-builder /go/src/github.com/leanote/leanote/mongodb_backup /leanote/mongodb_backup
COPY --from=node-builder /go/src/github.com/leanote/leanote/public /leanote/public

RUN apk add --no-cache --update wget ca-certificates \
    && mkdir -p /leanote/data/public/upload \
    && mkdir -p /leanote/data/files \
    && mkdir -p /leanote/data/mongodb_backup \
    && ln -s /leanote/data/public/upload /leanote/public/upload \
    && ln -s /leanote/data/files /leanote/files \
    && ln -s /leanote/data/mongodb_backup /leanote/mongodb_backup

RUN echo '@community http://dl-cdn.alpinelinux.org/alpine/edge/community/' >> /etc/apk/repositories \
    && echo '@main http://dl-cdn.alpinelinux.org/alpine/edge/main/' >> /etc/apk/repositories \
    && apk add --no-cache --update libressl2.7-libcrypto@main libressl2.7-libssl@main libressl2.7-libtls@main mongodb-tools@community

VOLUME /leanote/data/

EXPOSE 9000

CMD ["sh", "/leanote/bin/run.sh"]
