# Specify the platform and architecture
ARG TARGETOS=linux
ARG TARGETARCH=arm64

# Use Ubuntu 20.04 as the base image for arm64 architecture
FROM --platform=$TARGETOS/$TARGETARCH ubuntu:20.04

LABEL author="klldFN" maintainer="klld@klldFn.xyz"

RUN apt update && apt install -y \
    python3 \
    python3-pip \
    git \
    gcc \
    g++ \
    ca-certificates \
    dnsutils \
    curl \
    iproute2 \
    ffmpeg \
    procps \
    dumb-init \
    && useradd -m -d /home/container container

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

STOPSIGNAL SIGINT

# Copy the entrypoint script and make it executable
COPY --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Use dumb-init as the entrypoint
ENTRYPOINT ["dumb-init", "--"]
CMD ["/entrypoint.sh"]
