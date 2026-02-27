# --- Stage 1: The Builder ---
FROM alpine:3.23 AS builder

# Install build dependencies
# Added: linux-headers (for asm/types.h), opencore-amr-dev, pulseaudio-dev
RUN apk add --no-cache \
    build-base \
    linux-headers \
    make \
    openssl-dev \
    alsa-lib-dev \
    pulseaudio-dev \
    opus-dev \
    speex-dev \
    speexdsp-dev \
    portaudio-dev \
    opencore-amr-dev \
    curl \
    tar \
    python3 \
    git

# Define the PJPROJECT version
ARG PJPROJECT_VERSION=2.16
ENV PJPROJECT_VERSION=${PJPROJECT_VERSION}

# Download and extract the source tarball
WORKDIR /src
RUN curl -L https://github.com/pjsip/pjproject/archive/refs/tags/${PJPROJECT_VERSION}.tar.gz | tar xz --strip-components=1

# Here is exactly how you arrive at that number. PJSIP maps its TLS protocols to an enumerator (pj_ssl_sock_proto) using bit shifts. To combine them, you add the integer values together (which acts as a bitwise OR operation):
#
# TLS 1.0 (PJ_SSL_SOCK_PROTO_TLS1) = 1 << 2 = 4
# TLS 1.1 (PJ_SSL_SOCK_PROTO_TLS1_1) = 1 << 3 = 8
# TLS 1.2 (PJ_SSL_SOCK_PROTO_TLS1_2) = 1 << 4 = 16
# TLS 1.3 (PJ_SSL_SOCK_PROTO_TLS1_3) = 1 << 5 = 32
#
# DPJSIP_SSL_DEFAULT_PROTO: 4 + 8 + 16 + 32 = 60

# Configure and compile with OpenSSL v3 support
# Removed: --disable-sound, --disable-opencore-amr
RUN export CFLAGS="$CFLAGS -fPIC \
    -DPJSIP_SSL_DEFAULT_METHOD=34 \
    -DPJSIP_SSL_DEFAULT_PROTO=60 \
    -DPJMEDIA_CODEC_L16_HAS_8KHZ_MONO=1 \
    -DPJMEDIA_CODEC_L16_HAS_8KHZ_STEREO=1 \
    -DPJMEDIA_CODEC_L16_HAS_16KHZ_MONO=1 \
    -DPJMEDIA_CODEC_L16_HAS_16KHZ_STEREO=1" \
    && ./configure \
    --prefix=/usr/local \
    --enable-shared \
    --disable-resample \
    --disable-video \
    --disable-libyuv \
    --with-external-speex \
    --with-ssl=/usr \
    CFLAGS="-O2 -DNDEBUG" \
    LDFLAGS="-lspeexdsp" \
    && make dep \
    && make \
    && make install

# --- Stage 2: The Final Minimal Image ---
FROM alpine:3.23

# Install only essential runtime libraries
# Added: libuuid
RUN apk add --no-cache \
    libstdc++ \
    openssl \
    alsa-lib \
    libpulse \
    opus \
    speex \
    speexdsp \
    portaudio \
    opencore-amr \
    libuuid

# Copy ALL compiled libraries and binary
# Changed from libpj*.so* to *.so*
COPY --from=builder /usr/local/lib/*.so* /usr/local/lib/
COPY --from=builder /src/pjsip-apps/bin/pjsua-* /usr/local/bin/pjsua

# Set library path
ENV LD_LIBRARY_PATH=/usr/local/lib

# ENTRYPOINT ["pjsua"]
# CMD ["--help"]