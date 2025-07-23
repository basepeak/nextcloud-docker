FROM nextcloud:31.0.7-apache

LABEL org.opencontainers.image.source="https://github.com/basepeak/nextcloud-docker"

# libheif update for Debian Bookworm (fixes HEIC preview for iOS 18 images)
ENV DEBIAN_FRONTEND=noninteractive

# Set versions
ARG LIB_HEIF_VERSION=1.19.8
ARG IM_VERSION=7.1.1-47

RUN apt-get remove --purge php-imagick imagemagick libmagickcore-6.q16-6 libmagickwand-6.q16-6; \
    pecl uninstall imagick

# Add Sury PHP repo (required for php-dev packages)
RUN apt-get update && apt-get install -y \
    gnupg2 \
    ca-certificates \
    wget \
    lsb-release \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
    && wget -qO - https://packages.sury.org/php/apt.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/php.gpg \
    && apt-get update

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git make pkg-config autoconf curl cmake clang ca-certificates \
    libde265-0 libde265-dev libjpeg62-turbo libjpeg62-turbo-dev x265 libx265-dev libtool \
    libpng16-16 libpng-dev libjpeg62-turbo libjpeg62-turbo-dev ghostscript libxml2-dev \
    libtiff-dev libfontconfig1-dev libfreetype6-dev fonts-dejavu liblcms2-2 liblcms2-dev

# Build and install libheif
RUN git clone -b v${LIB_HEIF_VERSION} --depth 1 https://github.com/strukturag/libheif.git && \
    cd libheif && mkdir build && cd build && cmake --preset=release .. && make && make install && \
    ldconfig /usr/local/lib && cd ../.. && rm -rf libheif

# Build and install ImageMagick
RUN git clone -b ${IM_VERSION} --depth 1 https://github.com/ImageMagick/ImageMagick.git && \
    cd ImageMagick && ./configure --without-magick-plus-plus --disable-docs --disable-static && \
    make && make install && ldconfig /usr/local/lib && cd .. && rm -rf ImageMagick

RUN apt-get update && apt-get install -y --no-install-recommends && \
    pecl install imagick && docker-php-ext-enable imagick

RUN apt-get update; \
    apt-get install -y --no-install-recommends \
        clamav \
        clamav-daemon \
        ffmpeg \
        ghostscript \
        procps \
        screen \
        vim \
        less \
        ripgrep \
        jq \
        nano \
    ; \
    rm -rf /var/lib/apt/lists/*
