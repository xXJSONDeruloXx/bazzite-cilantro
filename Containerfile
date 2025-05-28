# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image - Using Fedora Asahi Remix as base (designed for Apple Silicon/ARM64)
FROM quay.io/fedora-asahi-remix-atomic-desktops/silverblue:42

## Original base was AMD64 only and causing exec format errors:
# FROM ghcr.io/ublue-os/bazzite:stable
#
# We're now using Fedora Asahi Remix which is specifically designed for Apple Silicon
# and already includes all the necessary drivers and kernel for M1/M2/M3 Macs.
# 
# Alternative Asahi Remix images:
# FROM quay.io/fedora-asahi-remix-atomic-desktops/kinoite:42 (KDE version)
# FROM quay.io/fedora-asahi-remix-atomic-desktops/base-atomic:42 (minimal version)

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

ARG TARGETARCH=arm64
ENV TARGETARCH=${TARGETARCH}

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    ostree container commit
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint