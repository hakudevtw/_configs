# Handover: continue at the home machine

Written 2026-10-02 on the work machine. Read this first, then continue with the **macOS system settings** work. Delete this file once the home machine is done.

## How the user wants to work

- Traditional Chinese for everything the user reads.
- One decision at a time, with a recommendation, based on trends and trade-offs. Click-through questions are welcome (AskUserQuestion), but keep each one small.
- Do not move on before the user says so. Do not dump long lists.
- Commit only when asked, in small segments. Never push for them.
- The user runs anything that needs `sudo` or a password. Claude only writes scripts.
- Never ask the user to paste passwords, tokens or notes. Claude must not read `local.zsh` (it is in the deny rules).

## State of the repo

- Everything is committed on `main` and **not pushed**. Push from the work machine before going home, otherwise this file is not there.
- Work machine is finished: Homebrew apps, mise (Node, pnpm, bun), starship, Karabiner (external keyboard only), Ghostty, Cursor extensions (list in `configs/cursor-extensions.txt`), Bitwarden vault tidied.
- Runbook for the home machine: README, section "整頓一台已經在用的電腦". Steps: profile `personal`, Ghostty with App Management permission, `scripts/brew-install.sh --dry-run`, then real run, `scripts/link-terminal-config.sh`, `scripts/install-extensions.sh`, then `scripts/brew-check.sh --apply` to remove replaced tools one by one.
- Bitwarden rules: `resources/BITWARDEN.md`, including a home checklist (recovery code on paper, auto-lock time, Chrome password saving off, iPhone setup, encrypted export).

## Next task: macOS system settings script

Goal: a script `scripts/macos-defaults.sh` that applies chosen settings with `defaults write`, safe to run twice, aware of the profile (`work` or `personal`). Anything that needs `sudo` goes in a separate clearly marked part. Existing checklist: `resources/SYSTEM_SETTINGS.md`.

Reading settings is allowed (`defaults read`, `mdutil -s`). Writing is done by the user.

### Already decided

| Topic | Decision |
|---|---|
| Spotlight shortcut (Cmd+Space) | Already off on the work machine; Raycast owns it. Script should make sure it is off on the home machine too |
| Spotlight and external drives | Turn indexing off **only for external volumes**, keep the system volume indexed (Raycast file search relies on the Spotlight index, not verified). Write a small command that loops over `/Volumes` except the system disk, runs `sudo mdutil -i off` and creates `.metadata_never_index` where writable |
| Finder | Show all file extensions: **yes**. Folders first, no `.DS_Store` on network drives, show hidden files: user wants to decide at home |

| Menu bar icons | Hide the icon of apps whose icon is not needed. Karabiner is already done in `configs/karabiner.json` (`global.show_in_menu_bar: false`). Scroll Reverser and AltTab are hidden by hand on the work machine and still have to go into the script: `defaults write com.pilotmoon.scroll-reverser HideIcon -bool true`, `defaults write com.lwouis.alt-tab-macos menubarIconShown -bool false`. Decided with the user: hide Raycast and Bitwarden (manual toggles, no `defaults` key found), keep Notion Calendar, Shottr, Caffeine, Stats. OrbStack: `defaults write dev.kdrag0n.MacVirt global_showMenubarExtra -bool false`. LINE and Claude have no setting of their own: the home machine runs macOS 26, so switch them off in System Settings → Menu Bar → Allow in the Menu Bar (not scriptable as far as known); the work machine runs macOS 15 and is left alone. All steps are in `resources/SYSTEM_SETTINGS.md`, section Menu Bar Icons |

### Still to decide, one group at a time

Dock (auto-hide, size, recent apps, Mission Control space ordering), keyboard (key repeat speed and delay, press-and-hold), trackpad and scrolling (tap to click, natural scrolling; Scroll Reverser also exists), text input (auto-capitalise, smart period, auto-correct), screenshots (save location, shadow), appearance, Login Items, Hot Corners, energy and sleep, FileVault and firewall (read-only checks only), anything that differs between work and personal.

### Current values on the work machine (for comparison)

| Setting | Value |
|---|---|
| Dock auto-hide | off, tile size 45, recent apps hidden |
| Finder | path bar on, default list view |
| Tap to click | on |
| Auto-capitalise, smart period | on |
| Appearance | dark |
| Key repeat, extensions, screenshot location, natural scrolling, spelling correction, `.DS_Store` on network, Mission Control ordering | never set (system defaults) |

Read the home machine's values the same way before asking the user anything.

## Leftovers on the work machine (user's own steps, status unknown)

- `sudo rm -rf ~/.local/share/fnm` (root-owned leftovers).
- Docker Desktop leftovers: the `com.docker.socket` daemon and helper (`sudo launchctl bootout system/com.docker.socket`, then remove the plist and the helper).
- Empty the Trash.

## Still open elsewhere

- AWS course accounts parked in the Bitwarden `Archive` folder: check billing and close the accounts before deleting the entries.
- Optional: `brew upgrade git gh` (and others); the install script deliberately uses `--no-upgrade`.
- Not started: macOS defaults script (this task), syncing Karabiner and lazygit config changes back into the repo.

## Prompt to start the next session

> Read `docs/HANDOVER.md` and continue with the macOS settings script. Start by reading this machine's current values, then ask me one group of settings at a time.
