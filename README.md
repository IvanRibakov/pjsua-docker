# pjsua-docker

A minimal Alpine Linux based Docker image for the PJSUA SIP user agent. This image is built from official PJSIP project sources.

## Overview

The primary goal of this repository is to provide a lightweight and up-to-date Docker image for PJSUA. This image compiles PJSUA from source using a multi-stage Docker build, ensuring a minimal final image size.

## Features

- **Minimal Base Image**: Uses Alpine Linux for a small footprint
- **Built from Source**: Compiles PJSUA from official PJSIP project sources
- **TLS Support**: Full support for SIP over TLS (SIPS) for secure communications
- **Multi-stage Build**: Uses Docker multi-stage builds to minimize final image size
- **Version Tagging**: Images can be tagged to match the PJSIP release version

## Usage

### Prerequisites

Docker installed on your system.

### Building the Image

To build the image yourself, you can clone the repository and use the `docker build` command:

```bash
git clone https://github.com/IvanRibakov/pjsua-docker.git
cd pjsua-docker
docker build -t pjsua .
```

You can also specify the PJSIP version to build using a build argument:

```bash
docker build --build-arg PJSIP_VERSION=2.16 -t pjsua:2.16 .
```

### Running PJSUA

To run PJSUA using this Docker image:

```bash
docker run --rm -it pjsua --help
```

To make a SIP call:

```bash
docker run --rm -it --network host pjsua sip:user@domain.com
```

Where:
- `--network host` allows the container to use the host's network stack for SIP/RTP traffic
- `sip:user@domain.com` is the SIP URI you want to call

## Building From Template

This Docker image is based on the [sipp-docker](https://github.com/IvanRibakov/sipp-docker) template, adapted to build PJSUA instead of SIPp.

## License

This project is licensed under the MIT License. PJSIP itself is licensed under GPL v2 or later.

