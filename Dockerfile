FROM nextcloud:31.0.7-apache

LABEL org.opencontainers.image.source="https://github.com/basepeak/nextcloud-docker"

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        clamav \
        clamav-daemon \
        ffmpeg \
        ghostscript \
        libmagickcore-6.q16-6-extra \
        procps \
        screen \
        vim \
        less \
        ripgrep \
        jq \
    ; \
    rm -rf /var/lib/apt/lists/*

# Copy disable apps script to post-installation directory
COPY disable-apps.sh /docker-entrypoint-hooks.d/post-installation/disable-apps.sh
RUN chmod +x /docker-entrypoint-hooks.d/post-installation/disable-apps.sh

