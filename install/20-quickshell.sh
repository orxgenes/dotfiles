#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

require_non_root
require_sudo

log "Checking for Quickshell package"

if has_package quickshell; then
    log "Installing Quickshell from enabled Fedora repositories"
    install_packages quickshell
else
    cat <<'EOF'

Quickshell is not available from the currently enabled Fedora repositories.

No third-party repository will be added automatically.

Install Quickshell using the currently supported upstream/Fedora
packaging method, then rerun this script.

EOF
    exit 1
fi

log "Verifying installation"

if command -v qs >/dev/null 2>&1; then
    qs --version || true
else
    die "Quickshell package installed but 'qs' was not found."
fi

log "Quickshell installation complete"