#!/usr/bin/env bash
# Install the Cursor extensions listed in configs/cursor-extensions.txt.
# Already-installed ones are skipped; nothing is ever uninstalled.
#
# Usage: ./scripts/install-extensions.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

LIST="$CONFIGS_ROOT/configs/cursor-extensions.txt"

if ! command -v cursor >/dev/null 2>&1; then
  err "cursor command not found. Install Cursor first, then run: Cursor > Cmd+Shift+P > 'Install cursor command'"
  exit 1
fi

INSTALLED="$(cursor --list-extensions | tr '[:upper:]' '[:lower:]')"

while IFS= read -r -u 3 ext; do
  [ -n "$ext" ] || continue
  if grep -qxF "$(echo "$ext" | tr '[:upper:]' '[:lower:]')" <<<"$INSTALLED"; then
    continue
  fi
  cursor --install-extension "$ext" || warn "Could not install $ext"
done 3< <(grep -v '^[[:space:]]*#' "$LIST")

ok "Extensions are in sync with $LIST"
