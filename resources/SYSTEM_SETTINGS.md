# System Settings

macOS settings to configure on a new machine. Adjust to taste — this is a checklist, not a script.

## General

- [ ] **Language & Region** — Preferred language, date/time format, and region.
- [ ] **Login Items** — Add Raycast, Karabiner-Elements, Scroll Reverser, and other apps that should start at login.

## Keyboard

Karabiner-Elements handles most custom key mappings; its config is `configs/karabiner.json`. It only grabs the external keyboard: the built-in keyboard is `ignore`d, because Karabiner's single virtual keyboard is ANSI and breaks a JIS built-in keyboard (see resources/TOOLS.md).

- [ ] **Keyboard** — Key repeat rate and delay until repeat.
- [ ] **Input Sources** — Layouts and shortcuts for switching languages.
- [ ] **Modifier Keys** — Caps Lock, Option, and Command behavior per device (if not handled by Karabiner).

## Trackpad & Mouse

Scroll Reverser sets scroll direction per device. Use it instead of (or alongside) System Settings when mixing trackpad and mouse.

- [ ] **Trackpad** — Tap to click, natural scrolling (if not overridden by Scroll Reverser).
- [ ] **Mouse** — Pointer speed and secondary click.
- [ ] **Scroll Reverser** — Per-device scroll direction for trackpad vs. mouse.

## Display & Appearance

- [ ] **Appearance** — Light, dark, or auto.
- [ ] **Wallpaper** — Desktop background.
- [ ] **Displays** — Resolution, scaling, and arrangement for external monitors.

## Finder

Finder → Settings. The sidebar is stored by the system and cannot be scripted.

- [ ] **Sidebar** — Favorites: Applications, Desktop, Documents, Downloads, Pictures. Locations: your home folder, External disks, Trash. Turn off Recents, Shared, iCloud Drive, Cloud Storage, CDs, AirDrop, Bonjour computers, Connected servers and all Tags. Drag project folders (such as `_configs`) into Favorites.
- [ ] **General** — New Finder windows show Downloads; no drive icons on the desktop.
- [ ] **View menu** — Show Path Bar and Show Status Bar.

| Shortcut | Action |
|---|---|
| `Cmd+Shift+.` | Show or hide hidden files |
| `Cmd+Shift+G` | Go to a folder by path |
| `Cmd+Shift+A` | Applications |
| `Cmd+Shift+H` | Home folder |
| `Cmd+Shift+D` | Desktop |
| `Cmd+Option+L` | Downloads |
| `Cmd+Option+P` | Toggle the path bar |

## Privacy & Security

- [ ] **Accessibility** — Grant permissions for Karabiner-Elements, Raycast, Ghostty, and other automation tools.
- [ ] **Full Disk Access** — Only for apps that require it (e.g. terminal tools, backup).
- [ ] **FileVault** — Disk encryption on or off per your preference.

## Menu Bar Icons

Hidden by choice. Most of these can only be changed inside the app (the setting is not exposed as a `defaults` key), so do them by hand on each machine.

- [ ] **Raycast** — Settings → General → turn off "Show in Menu Bar". On recent macOS it also has to be allowed in System Settings → Menu Bar.
- [ ] **Bitwarden** — Preferences → App settings (all accounts) → turn off "Show menu bar icon".
- [ ] **Karabiner-Elements** — Already hidden through `configs/karabiner.json` (`global.show_in_menu_bar`).
- [ ] **Scroll Reverser** — Preferences → turn on "Hide menu bar icon" (`defaults write com.pilotmoon.scroll-reverser HideIcon -bool true`).
- [ ] **AltTab** — Preferences → General → turn off the menu bar icon (`defaults write com.lwouis.alt-tab-macos menubarIconShown -bool false`).
- [ ] **OrbStack** — Settings → turn off the menu bar item (`defaults write dev.kdrag0n.MacVirt global_showMenubarExtra -bool false`).

- [ ] **Apps without their own setting (LINE, Claude, ...)** — macOS 26 only: System Settings → Menu Bar → "Allow in the Menu Bar", switch the app off. The app keeps running; only the icon goes away. macOS 15 has no per-app switch, leave those icons as they are.

Kept on purpose: Notion Calendar, Shottr (hiding it needs a paid license), Caffeine (the icon is the whole app), Stats (each monitor module is an icon; turn modules off inside Stats if needed).

## Sound & Notifications

- [ ] **Notifications** — Which apps can send alerts and how they appear.
- [ ] **Focus** — Do Not Disturb and focus modes.

## Network

- [ ] **Wi‑Fi / Ethernet** — Known networks and proxy settings if needed.
- [ ] **VPN** — Client and auto-connect rules if you use one.

## Backup & Sync

- [ ] **iCloud** — Drive, Photos, Keychain, and other sync toggles.
- [ ] **Time Machine** — Backup drive and schedule.
