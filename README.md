# pjsua-docker
A minimal Alpine Linux based Docker image for PJSUA (PJSIP User Agent). This image is built from official PJPROJECT sources with OpenSSL v3 support enabled.

## Overview
The primary goal of this repository is to provide a lightweight and up-to-date Docker image for PJSUA with full TLS/SSL support using OpenSSL v3. This image compiles PJPROJECT from source using a multi-stage Docker build, ensuring a minimal final image size while including essential features like TLS encryption and audio codec support.

This project automates the build and deployment process using GitHub Actions, publishing the resulting image to both GitHub Container Registry (GHCR) and Docker Hub.

## Features
Minimal Base Image: Uses alpine for a small footprint.

Built from Source: Compiles PJPROJECT from official sources with OpenSSL v3 support enabled.

TLS Support: Full support for SIP over TLS (SIPS) for secure communications.

Audio Codec Support: Includes Opus, Speex, and other audio codecs.

Multi-stage Build: Uses Docker multi-stage builds to minimize final image size.

Automated Builds: CI/CD pipeline with GitHub Actions.

Multi-registry Support: Publishes to GHCR and Docker Hub.

Version Tagging: Images are tagged to match the PJPROJECT release version.

## Usage
### Prerequisites
Docker installed on your system.

### Pulling the Image
You can pull the image from either GHCR or Docker Hub.

From Docker Hub:
```
docker pull YOUR_USERNAME/pjsua-docker:latest
```
From GHCR:
```
docker pull ghcr.io/YOUR_USERNAME/pjsua-docker:latest
```
### Running PJSUA
To run PJSUA using this Docker image:
```
docker run --rm -it --network host YOUR_USERNAME/pjsua-docker
```

For basic SIP registration:
```
docker run --rm -it --network host YOUR_USERNAME/pjsua-docker \
  --id sip:user@domain.com \
  --registrar sip:domain.com \
  --username user \
  --password password
```

To use with TLS:
```
docker run --rm -it --network host YOUR_USERNAME/pjsua-docker \
  --id sip:user@domain.com \
  --registrar sip:domain.com;transport=tls \
  --username user \
  --password password
```

### Building the Image Locally
If you need to build the image yourself, you can clone the repository and use the docker build command.
```
git clone https://github.com/YOUR_USERNAME/pjsua-docker.git
cd pjsua-docker
docker build -t pjsua-docker .
```
You can also specify the PJPROJECT version to build using a build argument:
```
docker build --build-arg PJPROJECT_VERSION=2.15 -t pjsua-docker:2.15 .
```
## Contributing
Contributions are welcome! If you find a bug or have a suggestion, please open an issue or submit a pull request.

1. Fork the repository.
2. Create a new branch: git checkout -b my-feature-branch
3. Make your changes.
4. Commit your changes: git commit -am 'Add some feature'
5. Push to the branch: git push origin my-feature-branch
6. Submit a pull request.

## License
This project is licensed under the MIT License - see the LICENSE file for details.