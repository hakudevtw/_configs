#!/usr/bin/env bash
# Apply macOS settings with `defaults write`. Safe to run twice: only settings that differ are written.
# The profile ("work" or "personal") is read from ~/.config/_configs/profile.
# Settings that only make sense for one machine are marked in the script; the rest apply to both.
#
# Usage:
#   ./scripts/macos-defaults.sh            # apply, then restart Dock, Finder and SystemUIServer
#   ./scripts/macos-defaults.sh --dry-run  # only print what would change
#   ./scripts/macos-defaults.sh --sudo     # the parts that need sudo (power settings, external drive indexing)
#
# Not scriptable, do these by hand: resources/SYSTEM_SETTINGS.md.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

PROFILE_FILE="$HOME/.config/_configs/profile"

MODE=apply
case "${1:-}" in
  "") ;;
  --dry-run) MODE=dry ;;
  --sudo) MODE=sudo ;;
  *) err "Unknown option: $1"; exit 1 ;;
esac

if [ ! -f "$PROFILE_FILE" ]; then
  err "No profile set. Run one of:"
  err "  mkdir -p ~/.config/_configs && echo work > $PROFILE_FILE"
  err "  mkdir -p ~/.config/_configs && echo personal > $PROFILE_FILE"
  exit 1
fi

PROFILE="$(tr -d '[:space:]' < "$PROFILE_FILE")"
case "$PROFILE" in
  work|personal) ;;
  *) err "Invalid profile '$PROFILE' in $PROFILE_FILE (use work or personal)"; exit 1 ;;
esac

CHANGED=0

# set_default [-currentHost] <domain> <key> <-bool|-int|-string> <value>
set_default() {
  local host=""
  if [ "$1" = "-currentHost" ]; then
    host="-currentHost"
    shift
  fi
  local domain=$1 key=$2 type=$3 value=$4 want current label
  label=$domain
  [ "$domain" = -g ] && label=global

  if [ "$type" = "-bool" ]; then
    if [ "$value" = true ]; then want=1; else want=0; fi
  else
    want=$value
  fi

  # shellcheck disable=SC2086 # $host is empty or a single flag
  current="$(defaults $host read "$domain" "$key" 2>/dev/null || echo "<unset>")"
  [ "$current" = "$want" ] && return 0

  CHANGED=$((CHANGED + 1))
  if [ "$MODE" = dry ]; then
    info "would set $label $key: $current → $want"
    return 0
  fi
  # shellcheck disable=SC2086
  defaults $host write "$domain" "$key" "$type" "$value"
  ok "$label $key: $current → $want"
}

# Same, but skip apps that have never run (no preferences file yet).
set_app_default() {
  if ! defaults read "$1" >/dev/null 2>&1; then
    warn "$1 has no preferences yet; open the app once and run this script again"
    return 0
  fi
  set_default "$@"
}

if [ "$MODE" = sudo ]; then
  info "Parts that need sudo (profile: $PROFILE)"

  if [ "$PROFILE" = personal ]; then
    # No wake from Power Nap, and no wake for network access while plugged in
    sudo pmset -a powernap 0
    sudo pmset -c womp 0
    ok "Power Nap and wake for network access are off"
  fi

  # Spotlight indexing off for external volumes only; the system volume stays indexed
  for vol in /Volumes/*; do
    [ -d "$vol" ] || continue
    # Internal volumes (system disk, Recovery) stay as they are
    diskutil info "$vol" 2>/dev/null | grep -q "Device Location: *External" || continue
    if mdutil -s "$vol" 2>/dev/null | grep -q "disabled"; then
      ok "Indexing already off: $vol"
    else
      sudo mdutil -i off "$vol" >/dev/null || warn "Could not turn indexing off for $vol"
      ok "Indexing off: $vol"
    fi
    [ -w "$vol" ] && touch "$vol/.metadata_never_index"
  done
  exit 0
fi

info "macOS settings (profile: $PROFILE, mode: $MODE)"

# Finder
set_default -g AppleShowAllExtensions -bool true
set_default com.apple.finder ShowPathbar -bool true
set_default com.apple.finder ShowStatusBar -bool true
set_default com.apple.finder _FXSortFoldersFirst -bool true
set_default com.apple.finder FXPreferredViewStyle -string Nlsv
set_default com.apple.finder FXDefaultSearchScope -string SCcf
set_default com.apple.finder NewWindowTarget -string PfLo
set_default com.apple.finder NewWindowTargetPath -string "file://$HOME/Downloads/"
set_default com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
set_default com.apple.finder ShowRemovableMediaOnDesktop -bool false
set_default com.apple.desktopservices DSDontWriteNetworkStores -bool true
set_default com.apple.desktopservices DSDontWriteUSBStores -bool true

# Dock and Mission Control
set_default com.apple.dock autohide -bool false
set_default com.apple.dock show-recents -bool false
set_default com.apple.dock magnification -bool false
set_default com.apple.dock mru-spaces -bool false
[ "$PROFILE" = personal ] && set_default com.apple.dock tilesize -int 42
# Hot corners: 1 = no action
for corner in tl tr bl br; do
  set_default com.apple.dock "wvous-$corner-corner" -int 1
  set_default com.apple.dock "wvous-$corner-modifier" -int 0
done
set_default com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# Keyboard: faster repeat, hold a key to repeat instead of the accent popup
set_default -g KeyRepeat -int 2
set_default -g InitialKeyRepeat -int 15
set_default -g ApplePressAndHoldEnabled -bool false

# Trackpad: tap to click, three-finger drag, four-finger swipe between Spaces, two-finger secondary click
for domain in com.apple.AppleMultitouchTrackpad com.apple.driver.AppleBluetoothMultitouch.trackpad; do
  set_default "$domain" Clicking -bool true
  set_default "$domain" TrackpadThreeFingerDrag -bool true
  set_default "$domain" TrackpadFourFingerHorizSwipeGesture -int 2
  set_default "$domain" TrackpadRightClick -bool true
done
set_default -currentHost -g com.apple.mouse.tapBehavior -int 1
set_default -g com.apple.mouse.tapBehavior -int 1

# Text input: no auto-correction (the work machine keeps its current behaviour)
if [ "$PROFILE" = personal ]; then
  set_default -g NSAutomaticCapitalizationEnabled -bool false
  set_default -g NSAutomaticPeriodSubstitutionEnabled -bool false
  set_default -g NSAutomaticSpellingCorrectionEnabled -bool false
  set_default -g NSAutomaticQuoteSubstitutionEnabled -bool false
  set_default -g NSAutomaticDashSubstitutionEnabled -bool false
fi

# Screenshots: own folder, no window shadow
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
[ "$MODE" = dry ] || mkdir -p "$SCREENSHOT_DIR"
set_default com.apple.screencapture location -string "$SCREENSHOT_DIR"
set_default com.apple.screencapture disable-shadow -bool true

# Menu bar icons of apps that expose a setting (the rest is by hand, see resources/SYSTEM_SETTINGS.md)
set_app_default com.pilotmoon.scroll-reverser HideIcon -bool true
# AltTab keeps this one as a string
set_app_default com.lwouis.alt-tab-macos menubarIconShown -string false
set_app_default dev.kdrag0n.MacVirt global_showMenubarExtra -bool false

# Cmd+Space belongs to Raycast, so the Spotlight shortcut (symbolic hotkey 64) must stay off
HOTKEYS="$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"
if [ "$(/usr/libexec/PlistBuddy -c "Print :AppleSymbolicHotKeys:64:enabled" "$HOTKEYS" 2>/dev/null)" = true ]; then
  CHANGED=$((CHANGED + 1))
  if [ "$MODE" = dry ]; then
    info "would turn the Spotlight shortcut off"
  else
    /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:enabled false" "$HOTKEYS"
    ok "Spotlight shortcut off (log out and back in to apply)"
  fi
fi

if [ "$CHANGED" -eq 0 ]; then
  ok "Nothing to change"
elif [ "$MODE" = dry ]; then
  info "$CHANGED setting(s) would change"
else
  killall Dock Finder SystemUIServer 2>/dev/null || true
  ok "$CHANGED setting(s) changed; Dock, Finder and SystemUIServer restarted"
  info "Keyboard and trackpad changes need a log out and back in"
fi

# Security: read-only, changing these is left to you
info "Security checks"
fde="$(fdesetup status 2>/dev/null || true)"
case "$fde" in
  *"is On"*) ok "FileVault is on" ;;
  *) warn "FileVault is not on: System Settings → Privacy & Security → FileVault" ;;
esac
if /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate 2>/dev/null | grep -q "enabled"; then
  ok "Firewall is on"
else
  warn "Firewall is off: System Settings → Network → Firewall"
fi
csrutil status 2>/dev/null | grep -q "enabled" && ok "SIP is on" || warn "SIP is off"
spctl --status 2>/dev/null | grep -q "enabled" && ok "Gatekeeper is on" || warn "Gatekeeper is off"

info "By hand (no setting to write): Liquid Glass slider, Dock Applications folder, sidebar, login items"
[ "$PROFILE" = personal ] && info "Needs sudo: ./scripts/macos-defaults.sh --sudo"
exit 0
