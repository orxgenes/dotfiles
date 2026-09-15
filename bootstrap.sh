#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib/common.sh
source "${SCRIPT_DIR}/install/lib/common.sh"

require_non_root
require_fedora

log "Installing prerequisites"
"${SCRIPT_DIR}/install/00-prerequisites.sh"

log "Installing Hyprland"
"${SCRIPT_DIR}/install/10-hyprland.sh"

log "Installing Quickshell"
"${SCRIPT_DIR}/install/20-quickshell.sh"

log "Linking configuration"
"${SCRIPT_DIR}/link.sh"

echo
echo "Bootstrap complete."
echo
echo "Next:"
echo "  1. Log out and start a Hyprland session."