#!/usr/bin/env bash
# Install apps and CLI tools from Brewfile + Brewfile.<profile> (+ ~/.config/_configs/Brewfile.local).
# The profile ("work" or "personal") is read from ~/.config/_configs/profile.
# Apps you already installed by hand are adopted by Homebrew instead of failing.
#
# Usage: ./scripts/brew-install.sh [--dry-run]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

OVERLAY_DIR="$HOME/.config/_configs"
PROFILE_FILE="$OVERLAY_DIR/profile"
LOCAL_BREWFILE="$OVERLAY_DIR/Brewfile.local"

DRY_RUN=false
[ "${1:-}" = "--dry-run" ] && DRY_RUN=true

if ! command -v brew >/dev/null 2>&1; then
  err "Homebrew not found. Install it first: https://brew.sh"
  exit 1
fi

if [ ! -f "$PROFILE_FILE" ]; then
  err "No profile set. Run one of:"
  err "  mkdir -p $OVERLAY_DIR && echo work > $PROFILE_FILE"
  err "  mkdir -p $OVERLAY_DIR && echo personal > $PROFILE_FILE"
  exit 1
fi

PROFILE="$(tr -d '[:space:]' < "$PROFILE_FILE")"
case "$PROFILE" in
  work|personal) ;;
  *) err "Invalid profile '$PROFILE' in $PROFILE_FILE (use work or personal)"; exit 1 ;;
esac

MERGED="$(mktemp -t brewfile)"
trap 'rm -f "$MERGED"' EXIT

for f in "$CONFIGS_ROOT/Brewfile" "$CONFIGS_ROOT/Brewfile.$PROFILE" "$LOCAL_BREWFILE"; do
  [ -f "$f" ] || continue
  info "Including $f"
  cat "$f" >> "$MERGED"
  echo >> "$MERGED"
done

if [ "$DRY_RUN" = true ]; then
  info "Dry run (profile: $PROFILE). Missing items:"
  brew bundle check --file="$MERGED" --verbose || true
  exit 0
fi

info "Installing for profile: $PROFILE"

# brew bundle fails on casks whose app already exists; adopt those first.
# The list is read from fd 3 so brew keeps the real stdin (it may ask for a sudo password).
while IFS= read -r -u 3 cask; do
  [ -n "$cask" ] || continue
  brew list --cask "$cask" >/dev/null 2>&1 && continue
  brew install --cask --adopt "$cask" || warn "Could not install cask $cask"
done 3< <(brew bundle list --cask --file="$MERGED")

brew bundle --no-upgrade --file="$MERGED" || warn "Some Brewfile entries failed (see above); mas needs an App Store sign-in"

if command -v mise >/dev/null 2>&1; then
  info "Installing runtimes from configs/mise.toml"
  mise install
fi

ok "Brew install finished"
info "Replaced or obsolete tools you can remove: scripts/brew-check.sh"
