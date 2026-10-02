# Handover: continue at the work machine

Written 2026-10-03 on the home machine, which is now finished. Read this first, then bring the work machine in line. Delete this file once the work machine is done.

## How the user wants to work

- Traditional Chinese for everything the user reads.
- One decision at a time, with a recommendation. Click-through questions (AskUserQuestion) are welcome, but keep each one small.
- Do not move on before the user says so. Do not dump long lists.
- Commit only when asked, in small segments. Push only when asked.
- The user runs anything that needs `sudo` or a password. Claude only writes scripts and reads state.
- Never ask the user to paste passwords, tokens, notes or a Raycast export. Claude must not read `local.zsh` (it is in the deny rules).
- Reading settings is fine (`defaults read`, `pmset -g custom`, `launchctl print`). Writing is done by the user.

## What changed on the home machine (all pushed to `main`)

- Home machine was updated to macOS 27 and tidied: Homebrew apps, mise, starship, Karabiner, Ghostty, Cursor extensions, system settings, Raycast v2.
- `scripts/macos-defaults.sh` applies the settings in one go: `--dry-run` previews, no argument applies, `--sudo` does the parts that need sudo. It also prints read-only security checks. Text input and the Dock tile size are only applied for the `personal` profile; the rest applies to both.
- Caffeine was replaced by the Raycast Coffee extension. It is gone from the Brewfile and listed as `obsolete`, so `brew-check.sh` offers to remove it.
- `scripts/sync-mcp-config.sh` now writes only local MCP servers to Claude Desktop (remote ones made Claude Desktop warn on every launch).
- `configs/karabiner.json` has a rule for the home keyboard K500E-B94 (`9610:268`, Cmd and Option swapped). It does not match anything on the work machine.
- New docs: `resources/APPLE_NOTES.md`, a shortcut cheat sheet in `resources/TOOLS.md`, a Finder section in `resources/SYSTEM_SETTINGS.md`.

## Do on the work machine, in this order

1. `cd ~/_configs && git pull`. The profile must be `work`: `cat ~/.config/_configs/profile`.
2. Use **Ghostty**, not the terminal inside Claude. In System Settings → Privacy & Security → App Management turn Ghostty on, then **quit and reopen Ghostty** (the permission does not apply until it restarts).
3. `./scripts/brew-install.sh --dry-run`, then the real run. If a cask complains that the app already exists, that is the App Management permission again.
4. `./scripts/brew-check.sh`, then `--apply`. It will offer the old Caffeine (cask `caffeine` or `domzilla-caffeine`, whichever is installed) one by one.
5. `./scripts/link-terminal-config.sh`. It never overwrites an existing `~/.config/karabiner/karabiner.json`, so compare it with `configs/karabiner.json` by hand: `diff configs/karabiner.json ~/.config/karabiner/karabiner.json`.
6. `./scripts/install-extensions.sh` and `./scripts/link-agent-config.sh`. The second one also runs the MCP sync, which now removes the remote servers from Claude Desktop's config.
7. `./scripts/macos-defaults.sh --dry-run`. **Read the list before applying.** It also changes work-machine behaviour that was never touched before (Finder opens Downloads, fixed Spaces order, faster key repeat, hot corners off, screenshots go to `~/Pictures/Screenshots`, desktop drive icons off). Ask the user which of these they want on the work machine, and move any they do not want into the `personal` block of the script.
8. `./scripts/macos-defaults.sh --sudo` (the work profile only touches external drive indexing).
9. Raycast: see below.

## Raycast

- The settings (command hotkeys, aliases, disabled extensions, clipboard retention) live in Raycast's own encrypted database. Claude cannot read or write them.
- To copy them from the home machine: Raycast Settings → Advanced → Export, then Import on the work machine. The export is protected by a password the user chooses. Keep the file out of the repo and out of chat, and delete it after importing.
- If importing is more trouble than it is worth, redo the short list by hand:
  - Window management hotkeys (use the Maximize, Left/Right/Top/Bottom Half commands, `Ctrl+Opt` plus the arrow key, `Ctrl+Opt+M` for Maximize). Each command also needs to be enabled.
  - Clipboard History hotkey `Shift+Cmd+V`; Disabled Applications: Keychain Access, Passwords, Bitwarden, Ghostty.
  - Disable what is not used: AI, Dictation, Screen Awareness, MCP, Raycast for Teams, Raycast Notes, Raycast Focus, Typing Practice, Contacts, Calendar, Apple Shortcuts, Dictionary, Script Commands.
  - Installed from the Store at home: Git Repos, Kill Process, Color Picker, Google Chrome, Google Translate, Notion, Apple Notes, Coffee.

## If the work machine is updated to macOS 27

What went wrong at home, so it can be avoided:

- **Karabiner** gets its permissions reset. After the update open System Settings → Privacy & Security → Input Monitoring and make sure Karabiner is allowed. Until then its remapping is half working.
- **Accessibility** is now called **Device Control and Data Access** in Privacy & Security. Check Raycast, AltTab, Scroll Reverser and Karabiner there.
- Launchpad is gone; the Dock has an **Apps** icon. The Applications folder in the Dock (sort by name, grid) is the closest replacement. Turn off iPhone Apps in System Settings → Spotlight.
- The **Liquid Glass** slider is in System Settings → Appearance. The Finder sidebar is no longer floating and has colour icons again.
- A keyboard's Cmd and Option swap done in both System Settings → Keyboard → Modifier Keys and Karabiner cancels out. Do it in Karabiner only.
- After a restart, the first minute may show harmless MCP or config errors in Claude; check again once the network is up.
- Spotlight's Cmd+Space shortcut is kept off by `macos-defaults.sh`; Raycast owns it.

## Still open (not for the work machine)

- Home: the Bitwarden home checklist in `resources/BITWARDEN.md` (recovery code on paper, auto-lock, Chrome password saving off, iPhone, encrypted export).
- Home: tidy Apple Notes by `resources/APPLE_NOTES.md`; the old `Accounts` folder may hold credentials that belong in Bitwarden.
- AWS course accounts parked in the Bitwarden `Archive` folder: check billing and close the accounts before deleting the entries.
- Work machine leftovers (status unknown; they were cleaned on the home machine): empty the Trash; check `ls ~/.local/share/fnm` (root-owned leftovers, `sudo rm -rf` it); check `/Library/LaunchDaemons` and `/Library/PrivilegedHelperTools` for `com.docker.socket` and `com.docker.vmnetd` (`sudo launchctl bootout system/<name>`, then remove the plist and the helper).
- Optional: `brew upgrade git gh lazygit tlrc` (the install script uses `--no-upgrade`).

## Prompt to start the next session

> Read `docs/HANDOVER.md` and bring this work machine in line, one step at a time. Start by reading this machine's current state.
