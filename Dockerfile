ARG TARGETOS=linux
ARG TARGETARCH=arm64
FROM --platform=$TARGETOS/$TARGETARCH python:3.10-slim-bookworm

LABEL author="klldFN" maintainer="klld@klldFn.xyz"

RUN apt update \
    && apt -y install git gcc g++ ca-certificates dnsutils curl iproute2 ffmpeg procps \
    && apt install -y dumb-init \
    && useradd -m -d /home/container container \
    && useradd -m -d /home/klldFN klldFN \
    && mkdir -p /home/klldFN /home/container \
    && chown -R container:container /home/container \
    && chown -R klldFN:klldFN /home/klldFN

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

STOPSIGNAL SIGINT

COPY --chown=container:container ./../entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/entrypoint.sh"]
