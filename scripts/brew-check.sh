#!/usr/bin/env bash
# List installed tools that the Brewfiles mark as replaced or obsolete.
# Read-only: it prints the command to remove each one but never runs it.
#
# Usage: ./scripts/brew-check.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

PROFILE=""
[ -f "$HOME/.config/_configs/profile" ] && PROFILE="$(tr -d '[:space:]' < "$HOME/.config/_configs/profile")"

python3 - "$CONFIGS_ROOT" "$PROFILE" <<'PY'
import json
import os
import re
import subprocess
import sys
from pathlib import Path

root, profile = Path(sys.argv[1]), sys.argv[2]
files = [root / "Brewfile"] + ([root / f"Brewfile.{profile}"] if profile else [])


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
        if path.exists():
            hits.append((token, reason, f"rm -rf {path}"))
    elif token in formulae:
        hits.append((token, reason, f"brew uninstall {token}"))
    elif token in casks:
        hits.append((token, reason, f"brew uninstall --cask {token}"))

if not hits:
    print("Nothing to remove yet.")
else:
    print(f"{len(hits)} installed item(s) you can remove (nothing is removed for you):\n")
    for token, reason, cmd in hits:
        print(f"  {token:<28} {reason:<26} {cmd}")
if waiting:
    names = sorted({r for _, r in waiting})
    print(f"\nKept for now ({len(waiting)}): their replacements are not installed yet: {', '.join(names)}")

PY
