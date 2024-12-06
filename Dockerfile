ARG TARGETOS=linux
ARG TARGETARCH=arm64
FROM --platform=$TARGETOS/$TARGETARCH python:3.9-slim-bookworm

LABEL author="klldFN" maintainer="klld@klldFN.xyz"

RUN apt update \
    && apt -y install git gcc g++ ca-certificates dnsutils curl iproute2 ffmpeg procps wget \
    && useradd -m -d /home/container container \
    && useradd -m -d /home/klldFN klldFN \
    && mkdir -p /home/klldFN /home/container \
    && chown -R container:container /home/container \
    && chown -R klldFN:klldFN /home/klldFN

RUN wget http://ftp.us.debian.org/debian/pool/main/d/dumb-init/dumb-init_1.2.5-1_arm64.deb && \
    dpkg -i dumb-init_1.2.5-1_arm64.deb

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

STOPSIGNAL SIGINT

COPY --chown=container:container ./../entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/entrypoint.sh"]

