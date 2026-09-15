#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=install/lib/common.sh
source "${SCRIPT_DIR}/install/lib/common.sh"

usage() {
    cat <<'EOF'
Usage: bootstrap.sh [options]

Installs packages, then links this repository's configuration into ~/.config.

Options:
  --enable-copr   Pass through to 10-hyprland.sh: enable the Copr repository
                  that provides Hyprland and install it from there.
  -h, --help      Show this help.
EOF
}

hyprland_args=()

for arg in "$@"; do
    case "${arg}" in
        --enable-copr) hyprland_args+=(--enable-copr) ;;
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
require_fedora

failed=()

# Run every step even if an earlier one fails. A single unavailable package
# should not stop the configuration from being linked, which is independent
# of package installation and is what makes the machine usable.
run_step() {
    local label="$1"
    shift

    log "${label}"

    if "$@"; then
        return 0
    fi

    failed+=("${label}")
    warn "${label} failed; continuing"
}

run_step "Installing prerequisites" "${SCRIPT_DIR}/install/00-prerequisites.sh"
run_step "Installing Hyprland" \
    "${SCRIPT_DIR}/install/10-hyprland.sh" "${hyprland_args[@]}"
run_step "Installing Quickshell" "${SCRIPT_DIR}/install/20-quickshell.sh"
run_step "Linking configuration" "${SCRIPT_DIR}/link.sh"

if (( ${#failed[@]} > 0 )); then
    echo
    warn "Bootstrap finished with problems in: ${failed[*]}"
    echo
    echo "Fix the cause and rerun the failing step, for example:"
    echo "  make hyprland"
    echo
    exit 1
fi

echo
echo "Bootstrap complete."
echo
echo "Next:"
echo "  1. Log out and start a Hyprland session."