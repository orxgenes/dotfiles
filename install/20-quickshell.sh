#!/usr/bin/env bash

set -euo pipefail

if [[ "${EUID}" -eq 0 ]]; then
    echo "Run this script as a normal user."
    exit 1
fi

sudo -v

echo "==> Checking for Quickshell package"

if dnf info quickshell >/dev/null 2>&1; then
    echo "==> Installing Quickshell from enabled Fedora repositories"
    sudo dnf install -y quickshell
else
    echo
    echo "Quickshell is not available from the currently enabled Fedora repositories."
    echo
    echo "No third-party repository will be added automatically."
    echo
    echo "Install Quickshell using the currently supported upstream/Fedora"
    echo "packaging method, then rerun this script."
    exit 1
fi

echo "==> Verifying installation"

if command -v qs >/dev/null 2>&1; then
    qs --version || true
else
    echo "Quickshell package installed but 'qs' was not found."
    exit 1
fi

echo "==> Quickshell installation complete"