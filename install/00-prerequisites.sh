#!/usr/bin/env bash

set -euo pipefail

if [[ "${EUID}" -eq 0 ]]; then
    echo "Run this script as a normal user."
    exit 1
fi

sudo -v

echo "==> Updating package metadata"
sudo dnf makecache

echo "==> Installing base desktop dependencies"

sudo dnf install -y \
    git \
    curl \
    wget \
    jq \
    dbus \
    dbus-tools \
    polkit \
    xdg-utils \
    xdg-user-dirs \
    xdg-user-dirs-gtk \
    mesa-dri-drivers \
    mesa-vulkan-drivers

echo "==> Installing Kitty"

sudo dnf install -y kitty

echo "==> Ensuring user directories exist"

xdg-user-dirs-update

echo "==> Prerequisites complete"