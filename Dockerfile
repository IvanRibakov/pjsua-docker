# --- Stage 1: The Builder ---
FROM alpine:3.19 AS builder

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    linux-headers \
    openssl-dev \
    alsa-lib-dev \
    curl \
    tar

# Define the PJSIP version
ARG PJSIP_VERSION=2.16
ENV PJSIP_VERSION=${PJSIP_VERSION}

# Download and extract the source tarball
WORKDIR /src
RUN curl -L https://github.com/pjsip/pjproject/archive/refs/tags/${PJSIP_VERSION}.tar.gz | tar xz --strip-components=1

# Configure and compile
RUN ./configure --disable-video --disable-sound \
    && make dep \
    && make

# --- Stage 2: The Final Minimal Image ---
FROM alpine:3.19

# Install only essential runtime libraries
RUN apk add --no-cache \
    libstdc++ \
    openssl

# Copy only the pjsua binary
COPY --from=builder /src/pjsip-apps/bin/pjsua-* /usr/local/bin/pjsua

ENTRYPOINT ["pjsua"]
CMD ["--help"]
