#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

require_non_root
require_sudo

log "Installing Hyprland"

install_packages \
    hyprland \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal \
    xwayland

log "Installing basic desktop utilities"

install_packages \
    wofi \
    thunar \
    thunar-volman \
    gvfs \
    gvfs-mtp

log "Hyprland installation complete"