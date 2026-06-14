#!/usr/bin/env bash
# Symlink terminal config: shell (zsh) + emulator (Ghostty).
#
# Usage: ./scripts/link-terminal-config.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

info "Linking terminal config"

# Shell
link_path "$CONFIGS_ROOT/configs/zshrc" "$HOME/.zshrc"
link_path "$CONFIGS_ROOT/configs/spaceship.zsh" "$HOME/.config/spaceship.zsh"

# Terminal emulator
link_path "$CONFIGS_ROOT/configs/ghostty" "$HOME/.config/ghostty/config"
link_path "$CONFIGS_ROOT/configs/ghostty" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

ok "Terminal config linked"
