#!/usr/bin/env bash
#
# Shared helpers for the install scripts.
# Source this file, do not execute it directly.

set -euo pipefail

log() {
    printf '==> %s\n' "$*"
}

warn() {
    printf 'warning: %s\n' "$*" >&2
}

die() {
    printf 'error: %s\n' "$*" >&2
    exit 1
}

# Refuse to run as root. These scripts use sudo selectively, and running
# them entirely as root would leave root-owned files in the user's home.
require_non_root() {
    if [[ "${EUID}" -eq 0 ]]; then
        die "Run this script as a normal user; it will use sudo where needed."
    fi
}

require_fedora() {
    [[ -f /etc/fedora-release ]] \
        || die "This script supports Fedora only (/etc/fedora-release not found)."
}

# Cache sudo credentials once so the user is prompted a single time.
require_sudo() {
    command -v sudo >/dev/null 2>&1 || die "sudo is required but was not found."
    sudo -v || die "Could not obtain sudo credentials."
}

has_package() {
    dnf info "$1" >/dev/null 2>&1
}

install_packages() {
    [[ $# -gt 0 ]] || return 0
    sudo dnf install -y "$@"
}
