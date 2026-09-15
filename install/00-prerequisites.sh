#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

require_non_root
require_sudo

log "Updating package metadata"
sudo dnf makecache

log "Installing base desktop dependencies"

install_packages \
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

log "Installing Kitty"

install_packages kitty

log "Ensuring user directories exist"

xdg-user-dirs-update

log "Prerequisites complete"