FROM debian:jessie

ENV LEANOTE_VERSION=2.2.1

RUN apt update \
    && apt install -y wget ca-certificates \
    && wget https://iweb.dl.sourceforge.net/project/leanote-bin/2.2.1/leanote-linux-amd64-v${LEANOTE_VERSION}.bin.tar.gz \
    && apt remove -y wget \
    && tar -zxvf leanote-linux-amd64-v${LEANOTE_VERSION}.bin.tar.gz -C / \
    && mkdir -p /leanote/data/public/upload \
    && mkdir -p /leanote/data/files \
    && rm -r /leanote/public/upload \
    && rm leanote-linux-amd64-v${LEANOTE_VERSION}.bin.tar.gz \
    && ln -s /leanote/data/public/upload /leanote/public/upload \
    && ln -s /leanote/data/files /leanote/files \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt update \
    && apt install -y \
        # Tools to export pdf
        wkhtmltopdf \
        # Tools to backup mongodb
        mongodb-clients \
        # wkhtmltopdf headless workaround
        xvfb \
        # Additionnal dependencies for better rendering
        ttf-freefont \
        fontconfig \
        dbus \
        psmisc \
    # Chinese fonts
    && apt-get install -y \
        fonts-arphic-bkai00mp \
        fonts-arphic-bsmi00lp \
        fonts-arphic-gbsn00lp \
        fonts-arphic-gkai00mp \
        fonts-arphic-ukai \
        fonts-arphic-uming \
        ttf-wqy-zenhei \
        ttf-wqy-microhei \
        xfonts-wqy \
    && fc-cache \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    # Wrapper for xvfb
    && mv /usr/bin/wkhtmltopdf /usr/bin/wkhtmltopdf-origin \
    && \
    echo -e '#!/usr/bin/env sh\n\
Xvfb :0 -screen 0 1024x768x24 -ac +extension GLX +render -noreset & \n\
DISPLAY=:0.0 wkhtmltopdf-origin $@ \n\
killall Xvfb\
' > /usr/bin/wkhtmltopdf && \
    chmod +x /usr/bin/wkhtmltopdf

VOLUME /leanote/data/

EXPOSE 9000

CMD ["sh", "/leanote/bin/run.sh"]
