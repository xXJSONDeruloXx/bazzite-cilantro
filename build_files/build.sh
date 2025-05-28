#!/bin/bash

# Modified error handling: 
# - Removed "-e" to prevent immediate exit on command failure
# - We handle errors manually with || true where needed
set -oux pipefail

# Always build for ARM64 architecture
export BUILDAH_PLATFORM=linux/arm64

### Install packages

# Enable RPM Fusion repositories for additional packages
dnf5 install -y \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Update repositories to ensure we have the latest package information
dnf5 update -y --refresh

# Install essential packages for Apple Silicon hardware 
# Using --skip-broken and --skip-unavailable to handle package availability issues
# Avoiding known problematic packages like apple-firmware-m1 (already included in the base image)
dnf5 install -y --skip-broken --skip-unavailable \
  tmux \
  vim \
  htop \
  git \
  powertop \
  power-profiles-daemon \
  thermald

# Note: asahi-audio is already included in the Fedora Asahi Remix base image
# Note: apple-firmware-m1 is already included in the Fedora Asahi Remix base image
# Note: asahi-scripts is already included in the Fedora Asahi Remix base image

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

# Enable some COPRs for additional packages
# Using || true to prevent build failures if the COPR enable fails
dnf5 -y copr enable ublue-os/bling || true
dnf5 -y install --skip-broken --skip-unavailable ublue-os-bling || true
dnf5 -y copr enable ublue-os/staging || true
dnf5 -y install --skip-broken --skip-unavailable ublue-update || true

# Install gaming-related packages if needed
# dnf5 -y install --skip-broken --skip-unavailable lutris wine gamescope mangohud goverlay

# Add Flatpak repository and install basic apps
# Using || true to prevent build failures if the repository already exists
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true
flatpak remote-add --if-not-exists fedora oci+https://registry.fedoraproject.org || true

# Install essential Flatpaks
# Using || true to prevent build failures if installations fail
flatpak install -y --noninteractive flathub com.github.tchx84.Flatseal || true
flatpak install -y --noninteractive flathub com.mattjakeman.ExtensionManager || true
flatpak install -y --noninteractive flathub org.mozilla.firefox || true

#### Enable system services
# Using || true to prevent build failures if the service doesn't exist
systemctl enable podman.socket || true
systemctl enable power-profiles-daemon || true
systemctl enable thermald || true

# Cleanup
dnf5 -y copr disable ublue-os/staging || true
