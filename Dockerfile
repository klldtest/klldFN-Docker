ARG TARGETOS=linux
ARG TARGETARCH=arm64
FROM --platform=$TARGETOS/$TARGETARCH python:3.10-slim-bookworm

LABEL       author="klldFN" maintainer="klld@klldFn.xyz"

RUN         apt update \
            && apt -y install git gcc g++ ca-certificates dnsutils curl iproute2 ffmpeg procps tini \
            && useradd -m -d /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

STOPSIGNAL SIGINT

COPY        --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh
ENTRYPOINT  ["/usr/bin/tini", "-g", "--"]
CMD         ["/entrypoint.sh"]
