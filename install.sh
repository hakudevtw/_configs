#!/usr/bin/env bash
# Install everything on a new machine. One script per feature area.
#
# Before the first run: install Homebrew and set the machine profile
#   mkdir -p ~/.config/_configs && echo work > ~/.config/_configs/profile   # or: personal
#
# Usage: ./install.sh

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/common.sh
source "$ROOT/scripts/lib/common.sh"

info "Running install..."

if [ -f "$HOME/.config/_configs/profile" ]; then
  "$ROOT/scripts/brew-install.sh"
else
  warn "No machine profile at ~/.config/_configs/profile; skipping Homebrew apps (see README)"
fi

"$ROOT/scripts/install-shell.sh"
"$ROOT/scripts/link-terminal-config.sh"
"$ROOT/scripts/link-agent-config.sh"
"$ROOT/scripts/install-claude-code.sh"

echo
ok "Install complete"
