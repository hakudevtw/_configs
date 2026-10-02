#!/usr/bin/env bash
# List installed tools that the Brewfiles mark as replaced or obsolete.
# Without options it is read-only: it prints the command to remove each one.
# With --apply it asks y/N/q for every item and then removes it:
#   formula/cask  brew uninstall
#   npm:<pkg>     npm uninstall -g (the npm on PATH)
#   app:<Name>    moved to the Trash (reversible)
#   path:<dir>    deleted permanently, only inside $HOME; asks for sudo if root owns it
# app:Docker needs a typed confirmation because it also deletes Docker Desktop's data.
#
# Usage: ./scripts/brew-check.sh [--apply]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

PROFILE=""
[ -f "$HOME/.config/_configs/profile" ] && PROFILE="$(tr -d '[:space:]' < "$HOME/.config/_configs/profile")"

python3 - "$CONFIGS_ROOT" "$PROFILE" "${1:-}" <<'PY'
import json
import os
import re
import shutil
import subprocess
import sys
import time
from pathlib import Path

root, profile, mode = Path(sys.argv[1]), sys.argv[2], sys.argv[3]
apply_mode = mode == "--apply"
HOME = Path(os.path.expanduser("~")).resolve()
files = [root / "Brewfile"] + ([root / f"Brewfile.{profile}"] if profile else [])

# never delete these, even if a Brewfile asks
PROTECTED = {HOME / p for p in (
    "Documents", "Desktop", "Downloads", "Library", "Pictures", "Movies", "Music",
    ".ssh", ".config", ".claude", "_configs", ".local", ".Trash",
)}


def run(*cmd: str) -> str:
    r = subprocess.run(cmd, capture_output=True, text=True)
    return r.stdout if r.returncode == 0 else ""


formulae = set(run("brew", "list", "--formula", "-1").split())
casks = set(run("brew", "list", "--cask", "-1").split())
try:
    npm_globals = set(json.loads(run("npm", "ls", "-g", "--depth=0", "--json") or "{}").get("dependencies", {}))
except ValueError:
    npm_globals = set()

# (token, replacer) where replacer is the new tool, or None for "obsolete"
found = []
for f in files:
    if not f.exists():
        continue
    for line in f.read_text().splitlines():
        m = re.match(r'\s*(?:brew|cask)\s+"([^"]+)".*\|\s*replaces:\s*(.+)$', line)
        if m:
            found += [(t, m.group(1)) for t in m.group(2).split()]
        m = re.match(r"\s*#\s*obsolete:\s*(.+)$", line)
        if m:
            found += [(t, None) for t in m.group(1).split()]

hits, waiting = [], []
for token, replacer in found:
    if replacer and replacer not in formulae and replacer not in casks:
        # only suggest removal once the replacement is really installed
        waiting.append((token, replacer))
        continue
    reason = f"replaced by {replacer}" if replacer else "obsolete"
    if token.startswith("npm:"):
        name = token[4:]
        if name in npm_globals:
            hits.append((token, reason, f"npm uninstall -g {name}"))
    elif token.startswith("app:"):
        app = Path("/Applications") / f"{token[4:]}.app"
        if app.exists():
            hits.append((token, reason, f"move {app} to the Trash"))
    elif token.startswith("path:"):
        path = Path(os.path.expanduser(token[5:]))
        if path.exists() or path.is_symlink():
            hits.append((token, reason, f"rm -rf {path}"))
    elif token in formulae:
        hits.append((token, reason, f"brew uninstall {token}"))
    elif token in casks:
        hits.append((token, reason, f"brew uninstall --cask {token}"))


def trash(app: Path) -> bool:
    dest = HOME / ".Trash" / app.name
    if dest.exists():
        dest = HOME / ".Trash" / f"{app.stem} {int(time.time())}{app.suffix}"
    try:
        shutil.move(str(app), str(dest))
        return True
    except OSError as e:
        print(f"    could not move to the Trash ({e}); needs App Management permission for this terminal")
        return False


def remove_path(path: Path, tty) -> bool:
    resolved = path.resolve() if path.exists() else path
    if HOME not in resolved.parents or resolved in PROTECTED:
        print(f"    refusing to delete {path}: outside $HOME or protected")
        return False
    if path.is_symlink() or path.is_file():
        path.unlink()
        return True
    subprocess.run(["chmod", "-R", "u+w", str(path)], capture_output=True)
    shutil.rmtree(path, ignore_errors=True)
    if path.exists():
        print("    some files are owned by root")
        if ask("    delete the rest with sudo?", tty) == "y":
            subprocess.run(["sudo", "rm", "-rf", str(path)])
    return not path.exists()


def ask(prompt: str, tty) -> str:
    print(f"{prompt} [y/N/q] ", end="", flush=True)
    answer = tty.readline().strip().lower()
    return answer if answer in ("y", "q") else "n"


def remove_docker(tty) -> bool:
    data = HOME / "Library/Containers/com.docker.docker"
    size = run("du", "-sh", str(data)).split()[0] if data.exists() else "0"
    print(f"    WARNING: this also deletes Docker Desktop's data ({size}): images, containers and volumes.")
    print("    It cannot be undone. Migrating first: orb docker migrate")
    print("    Type 'delete docker data' to continue: ", end="", flush=True)
    if tty.readline().strip() != "delete docker data":
        return False
    uninstaller = Path("/Applications/Docker.app/Contents/MacOS/uninstall")
    if uninstaller.exists():
        subprocess.run([str(uninstaller)])
    app = Path("/Applications/Docker.app")
    return trash(app) if app.exists() else True


def apply_one(token: str, tty) -> bool:
    if token == "app:Docker":
        return remove_docker(tty)
    if token.startswith("npm:"):
        return subprocess.run(["npm", "uninstall", "-g", token[4:]]).returncode == 0
    if token.startswith("app:"):
        return trash(Path("/Applications") / f"{token[4:]}.app")
    if token.startswith("path:"):
        return remove_path(Path(os.path.expanduser(token[5:])), tty)
    cmd = ["brew", "uninstall"] + (["--cask"] if token in casks else []) + [token]
    return subprocess.run(cmd).returncode == 0


if not hits:
    print("Nothing to remove yet.")
elif not apply_mode:
    print(f"{len(hits)} installed item(s) you can remove (nothing is removed; add --apply to be asked one by one):\n")
    for token, reason, cmd in hits:
        print(f"  {token:<28} {reason:<26} {cmd}")
else:
    tty = open(os.environ.get("BREW_CHECK_TTY", "/dev/tty"))
    print(f"{len(hits)} item(s). Apps go to the Trash; paths are deleted for good. q stops.\n")
    removed = skipped = failed = 0
    for token, reason, cmd in hits:
        print(f"{token}  ({reason})\n    {cmd}")
        answer = ask("  Remove?", tty)
        if answer == "q":
            break
        if answer == "n":
            skipped += 1
            continue
        if apply_one(token, tty):
            removed += 1
            print("    done")
        else:
            failed += 1
            print("    not removed")
    print(f"\nremoved {removed}, skipped {skipped}, failed {failed}")

if waiting:
    names = sorted({r for _, r in waiting})
    print(f"\nKept for now ({len(waiting)}): their replacements are not installed yet: {', '.join(names)}")
PY
