FROM nextcloud:31.0.2-apache

LABEL org.opencontainers.image.source https://github.com/basepeak/nextcloud-docker

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        ghostscript \
        libmagickcore-6.q16-6-extra \
        procps \
    ; \
    rm -rf /var/lib/apt/lists/*
