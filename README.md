# Bazzite Cilantro - Bazzite for ARM/Apple Silicon

This repository provides a custom [bootc](https://github.com/bootc-dev/bootc) image based on Fedora Asahi Remix, designed specifically for Apple Silicon (M1/M2/M3) Macs. It combines the gaming-focused features of [Bazzite](https://bazzite.gg/) with the Apple Silicon hardware support from [Fedora Asahi Remix](https://asahilinux.org/fedora/).

## Features

- Built on Fedora Asahi Remix Silverblue, which includes all the necessary drivers and kernel patches for Apple Silicon
- Added Bazzite-specific features and tools for gaming and desktop use
- ARM64-compatible build process that runs on GitHub Actions
- Automatic updates via rpm-ostree and Fedora release tracking

## Installation

### Prerequisites

- An Apple Silicon Mac (M1, M2, or M3)
- [Asahi Linux installer](https://asahilinux.org/) already installed and running

### Install from Container Image

```bash
# 1. Install container signature verification
sudo mkdir -p /etc/pki/containers
curl -sL "https://github.com/YOUR_USERNAME/bazzite-cilantro/raw/main/cosign.pub" | sudo tee /etc/pki/containers/bazzite-cilantro.pub > /dev/null
sudo restorecon -RFv /etc/pki/containers

# 2. Rebase to the image
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/YOUR_USERNAME/bazzite-cilantro:latest

# 3. Reboot to apply changes
systemctl reboot
```

## Building Locally

To build this image locally:

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/bazzite-cilantro.git
cd bazzite-cilantro

# Build using podman
podman build -t bazzite-cilantro .

# Optionally, run the container to test it
podman run --rm -it bazzite-cilantro
```

## Customization

To customize this image for your own use:

1. Fork this repository
2. Edit the `Containerfile` to change the base image or add more layers
3. Modify `build_files/build.sh` to install different packages or make other changes
4. Update your GitHub Actions workflow to publish under your own namespace

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgements

- [Bazzite](https://bazzite.gg/) - For the original Bazzite project
- [Fedora Asahi Remix](https://asahilinux.org/fedora/) - For the Apple Silicon support
- [Universal Blue](https://ublue.it/) - For the ublue-os tools and container images
- [Asahi Linux](https://asahilinux.org/) - For the incredible work on Apple Silicon support in Linux

## License

This project is licensed under the Apache License 2.0 - see the LICENSE file for details.
