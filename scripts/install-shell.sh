#!/usr/bin/env bash
# Install Oh My Zsh (plain git clone, no remote script). The prompt (starship) and
# the zsh plugins come from the Brewfile; ~/.zshrc is linked by link-terminal-config.sh.
#
# Usage: ./scripts/install-shell.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

OMZ_DIR="$HOME/.oh-my-zsh"

if [ -d "$OMZ_DIR" ]; then
  ok "Oh My Zsh already installed"
else
  info "Cloning Oh My Zsh"
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$OMZ_DIR"
  ok "Oh My Zsh installed"
fi
