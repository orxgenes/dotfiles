#!/usr/bin/env bash
#
# Install Hyprland and the desktop utilities this configuration expects.
#
# Hyprland is not packaged in Fedora's own repositories, so it cannot be
# installed without a third-party repository. This script will not enable one
# on its own: pass --enable-copr to opt in, or install Hyprland by any other
# means (an upstream source build is detected and respected).

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

# Copr project used by --enable-copr. It provides both 'hyprland' and
# 'xdg-desktop-portal-hyprland' and builds for fedora-44 and fedora-45.
# Override it if you would rather use a different one:
#   HYPRLAND_COPR=someone/else make enable-hyprland-copr
HYPRLAND_COPR="${HYPRLAND_COPR:-sachesi/hyprland}"

ENABLE_COPR=0

usage() {
    cat <<EOF
Usage: 10-hyprland.sh [options]

Installs Hyprland and the desktop utilities used by this configuration.

Hyprland is not in Fedora's repositories. This script does not enable a
third-party repository unless you explicitly ask it to.

Options:
  --enable-copr   Enable the Copr repository '${HYPRLAND_COPR}' and install
                  Hyprland and its portal from it.
  -h, --help      Show this help.

Environment:
  HYPRLAND_COPR   Copr project for --enable-copr (default: ${HYPRLAND_COPR}).
EOF
}

for arg in "$@"; do
    case "${arg}" in
        --enable-copr) ENABLE_COPR=1 ;;
        -h | --help)
            usage
            exit 0
            ;;
        *)
            printf 'error: unknown argument: %s (try --help)\n' "${arg}" >&2
            exit 1
            ;;
    esac
done

require_non_root
require_sudo

log "Installing desktop utilities"

# 'xorg-x11-server-Xwayland' is Fedora's package name; there is no 'xwayland'.
# 'xdg-desktop-portal' is the base portal and is available from Fedora itself;
# only the Hyprland-specific backend needs the Copr repository.
install_available_packages \
    wofi \
    thunar \
    thunar-volman \
    gvfs \
    gvfs-mtp \
    xdg-desktop-portal \
    xorg-x11-server-Xwayland

log "Installing Hyprland"

if command -v Hyprland >/dev/null 2>&1; then
    log "Hyprland is already installed"
elif has_package hyprland; then
    install_available_packages hyprland xdg-desktop-portal-hyprland
elif (( ENABLE_COPR )); then
    log "Enabling Copr repository ${HYPRLAND_COPR}"
    sudo dnf copr enable -y "${HYPRLAND_COPR}"
    sudo dnf makecache

    install_available_packages hyprland xdg-desktop-portal-hyprland
else
    warn "Hyprland is not available from the enabled repositories."
    cat <<EOF

Hyprland is not packaged by Fedora. Choose one of:

  1. Opt in to the Copr repository this script knows about:

       make enable-hyprland-copr

     or a different project:

       HYPRLAND_COPR=owner/project make enable-hyprland-copr

  2. Build Hyprland from source and rerun this script; an existing
     'Hyprland' binary is detected and left alone.

EOF
fi

if ! command -v Hyprland >/dev/null 2>&1; then
    warn "Hyprland is still not installed; see the options above."
    exit 1
fi

log "Hyprland installation complete"