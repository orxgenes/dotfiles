#!/usr/bin/env bash
#
# Symlink this repository's configuration into ~/.config.
#
# Existing files are never deleted: a real file or a symlink pointing
# somewhere else is moved aside to <name>.bak.<timestamp> first, and
# --unlink restores the newest backup it finds.

set -euo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}"

# Each entry is a directory under config/ that maps onto ~/.config/<name>.
TARGETS=(hypr quickshell)

DRY_RUN=0
UNLINK=0

usage() {
    cat <<'EOF'
Usage: link.sh [options]

Symlink this repository's configs into ~/.config.

Options:
  --unlink    Remove the links, restoring the newest backup if present.
  --dry-run   Print what would happen without changing anything.
  -h, --help  Show this help.
EOF
}

for arg in "$@"; do
    case "${arg}" in
        --unlink) UNLINK=1 ;;
        --dry-run) DRY_RUN=1 ;;
        -h | --help) usage; exit 0 ;;
        *)
            printf 'error: unknown argument: %s\n\n' "${arg}" >&2
            usage >&2
            exit 1
            ;;
    esac
done

run() {
    if [[ "${DRY_RUN}" -eq 1 ]]; then
        printf '  [dry-run] %s\n' "$*"
    else
        "$@"
    fi
}

# Timestamp format is lexically sortable, so "newest backup" is simply the
# greatest name. Avoids depending on ls/find ordering.
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

link_one() {
    local name="$1"
    local src="${REPO_DIR}/config/${name}"
    local dest="${CONFIG_DIR}/${name}"

    [[ -d "${src}" ]] || die "missing ${src}"

    if [[ -L "${dest}" && "$(readlink -f "${dest}")" == "${src}" ]]; then
        printf '  %-12s already linked\n' "${name}"
        return 0
    fi

    if [[ -e "${dest}" || -L "${dest}" ]]; then
        printf '  %-12s moving existing aside -> %s.bak.%s\n' \
            "${name}" "${name}" "${TIMESTAMP}"
        run mv "${dest}" "${dest}.bak.${TIMESTAMP}"
    fi

    printf '  %-12s %s -> %s\n' "${name}" "${dest}" "${src}"
    run ln -s "${src}" "${dest}"
}

unlink_one() {
    local name="$1"
    local src="${REPO_DIR}/config/${name}"
    local dest="${CONFIG_DIR}/${name}"

    if [[ ! -L "${dest}" ]]; then
        if [[ -e "${dest}" ]]; then
            printf '  %-12s skipped, not a symlink\n' "${name}"
        else
            printf '  %-12s not linked\n' "${name}"
        fi
        return 0
    fi

    if [[ "$(readlink -f "${dest}")" != "${src}" ]]; then
        printf '  %-12s skipped, points elsewhere\n' "${name}"
        return 0
    fi

    printf '  %-12s removing %s\n' "${name}" "${dest}"
    run rm "${dest}"

    shopt -s nullglob
    local backups=("${dest}.bak."*)
    shopt -u nullglob

    if (( ${#backups[@]} > 0 )); then
        local newest="" b
        for b in "${backups[@]}"; do
            [[ "${b}" > "${newest}" ]] && newest="${b}"
        done

        printf '  %-12s restoring %s\n' "${name}" "${newest}"
        run mv "${newest}" "${dest}"
    fi
}

if [[ "${UNLINK}" -eq 1 ]]; then
    printf 'Unlinking configs from %s\n' "${CONFIG_DIR}"

    for target in "${TARGETS[@]}"; do
        unlink_one "${target}"
    done
else
    printf 'Linking configs into %s\n' "${CONFIG_DIR}"

    if [[ ! -d "${CONFIG_DIR}" ]]; then
        printf '  creating %s\n' "${CONFIG_DIR}"
        run mkdir -p "${CONFIG_DIR}"
    fi

    for target in "${TARGETS[@]}"; do
        link_one "${target}"
    done
fi

printf 'Done.\n'
