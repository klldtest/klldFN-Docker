ARG TARGETOS=linux
ARG TARGETARCH=arm64
FROM --platform=$TARGETOS/$TARGETARCH python:3.10-slim-bookworm

LABEL       author="klldFN" maintainer="klld@klldFn.xyz"


RUN apt update \
    && apt -y install git gcc g++ ca-certificates dnsutils curl iproute2 ffmpeg procps tini \
    && useradd -m -d /home/container container

# Set environment variables and working directory for the container user
USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

STOPSIGNAL SIGINT

# Copy the entrypoint script
COPY        --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh

# Use tini as the entrypoint
ENTRYPOINT  ["tini", "-g", "--"]
CMD         ["/entrypoint.sh"]
