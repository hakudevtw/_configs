#!/usr/bin/env bash
# Install Claude Code with the official native installer (it updates itself).
# Not in the Brewfile on purpose: see README "Manual installs". Do not mix with the brew cask or npm.
#
# Usage: ./scripts/install-claude-code.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

if command -v claude >/dev/null 2>&1; then
  ok "Claude Code already installed ($(claude --version 2>/dev/null || echo unknown version))"
  exit 0
fi

info "Installing Claude Code: downloading and running https://claude.ai/install.sh"
curl -fsSL https://claude.ai/install.sh | bash
ok "Claude Code installed"
