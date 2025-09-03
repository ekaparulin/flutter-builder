# Base image: Debian slim for small size
FROM debian:bullseye-slim

# Install dependencies for Flutter & build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash git unzip xz-utils curl zip libglu1-mesa ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter in /opt
WORKDIR /opt
RUN git clone https://github.com/flutter/flutter.git

RUN groupadd flutter -g 1111 \
    && useradd -u 1111 -r -g flutter -M -d /opt/flutter -s /sbin/nologin -c "Flutter builder" flutter \
    && chown -R flutter:flutter /opt/flutter \
    && mkdir /build && chown flutter:flutter /build

    
USER flutter
WORKDIR /opt/flutter

# Checkout Flutter version 3.35.2
RUN git fetch --tags && git checkout 3.35.2

# Add flutter to PATH
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Pre-cache Flutter to avoid first-run delays
RUN flutter doctor -v

# Default working directory for apps
WORKDIR /build
