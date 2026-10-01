#!/usr/bin/env bash
# Symlink terminal config: shell (zsh, starship, mise), git (delta), Karabiner + emulator (Ghostty).
#
# Usage: ./scripts/link-terminal-config.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

info "Linking terminal config"

# Shell
link_path "$CONFIGS_ROOT/configs/zshrc" "$HOME/.zshrc"
link_path "$CONFIGS_ROOT/configs/starship.toml" "$HOME/.config/starship.toml"
link_path "$CONFIGS_ROOT/configs/mise.toml" "$HOME/.config/mise/config.toml"

# Git: shared settings need delta, otherwise every `git diff` would fail on the missing pager
if command -v delta >/dev/null 2>&1; then
  link_path "$CONFIGS_ROOT/configs/gitconfig" "$HOME/.config/git/config"
else
  warn "delta not installed; skipping git config (run scripts/brew-install.sh, then this script again)"
fi

# Keyboard remapping. Karabiner replaces a symlinked karabiner.json with a plain file on every
# save from its GUI, so this is copied once instead of linked. After changing settings in the GUI,
# copy ~/.config/karabiner/karabiner.json back to configs/karabiner.json and commit.
KARABINER_DEST="$HOME/.config/karabiner/karabiner.json"
if [ -e "$KARABINER_DEST" ]; then
  warn "Karabiner config already exists, not overwriting. Compare: diff $CONFIGS_ROOT/configs/karabiner.json $KARABINER_DEST"
else
  mkdir -p "$(dirname "$KARABINER_DEST")"
  cp "$CONFIGS_ROOT/configs/karabiner.json" "$KARABINER_DEST"
  ok "Copied Karabiner config to $KARABINER_DEST"
fi

# Terminal emulator
link_path "$CONFIGS_ROOT/configs/ghostty" "$HOME/.config/ghostty/config"
link_path "$CONFIGS_ROOT/configs/ghostty" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

ok "Terminal config linked"
