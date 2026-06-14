#!/usr/bin/env bash
# Install all dotfile symlinks. One script per feature area.
#
# Usage: ./install.sh

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/common.sh
source "$ROOT/scripts/lib/common.sh"

info "Running install..."

"$ROOT/scripts/link-terminal-config.sh"
"$ROOT/scripts/link-agent-config.sh" --no-update

echo
ok "Install complete"
