#!/usr/bin/env bash

set -euo pipefail

if [[ "${EUID}" -eq 0 ]]; then
    echo "Run this script as a normal user."
    exit 1
fi

sudo -v

echo "==> Installing Hyprland"

sudo dnf install -y \
    hyprland \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal \
    xwayland

echo "==> Installing basic desktop utilities"

sudo dnf install -y \
    wofi \
    thunar \
    thunar-volman \
    gvfs \
    gvfs-mtp

echo "==> Hyprland installation complete"