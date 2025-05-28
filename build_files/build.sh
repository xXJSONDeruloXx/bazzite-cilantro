#!/bin/bash

set -ouex pipefail

# Always build for ARM64 architecture
export BUILDAH_PLATFORM=linux/arm64

### Install packages

# Enable RPM Fusion repositories for additional packages
dnf5 install -y \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Install essential packages for Apple Silicon hardware
dnf5 install -y \
  tmux \
  vim \
  htop \
  git \
  powertop \
  apple-firmware-m1 \
  asahi-audio \
  asahi-scripts \
  power-profiles-daemon \
  thermald

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

# Enable some COPRs for additional packages
dnf5 -y copr enable ublue-os/bling
dnf5 -y install ublue-os-bling
dnf5 -y copr enable ublue-os/staging
dnf5 -y install ublue-update

# Install gaming-related packages if needed
# dnf5 -y install lutris wine gamescope mangohud goverlay

# Add Flatpak repository and install basic apps
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists fedora oci+https://registry.fedoraproject.org

# Install essential Flatpaks
flatpak install -y flathub com.github.tchx84.Flatseal
flatpak install -y flathub com.mattjakeman.ExtensionManager
flatpak install -y flathub org.mozilla.firefox

#### Enable system services
systemctl enable podman.socket
systemctl enable power-profiles-daemon
systemctl enable thermald

# Cleanup
dnf5 -y copr disable ublue-os/staging
