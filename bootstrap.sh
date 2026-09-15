#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${EUID}" -eq 0 ]]; then
    echo "Do not run bootstrap.sh as root."
    echo "Run it as your normal user; the installation scripts will use sudo."
    exit 1
fi

if [[ ! -f /etc/fedora-release ]]; then
    echo "This bootstrap currently supports Fedora only."
    exit 1
fi

echo "==> Installing prerequisites"
"${SCRIPT_DIR}/install/00-prerequisites.sh"

echo "==> Installing Hyprland"
"${SCRIPT_DIR}/install/10-hyprland.sh"

echo "==> Installing Quickshell"
"${SCRIPT_DIR}/install/20-quickshell.sh"

echo
echo "Bootstrap complete."
echo
echo "Next:"
echo "  1. Copy/symlink the Hyprland configuration."
echo "  2. Copy/symlink the Quickshell configuration."
echo "  3. Start a Hyprland session."