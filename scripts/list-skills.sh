#!/usr/bin/env bash
# List installed skills and check the lock file, repo dirs and ~/.claude/skills agree.
#
# Usage: ./scripts/list-skills.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

python3 - "$AGENT_SKILLS_ROOT" "$HOME/.claude/skills" <<'PY'
import json
import re
import sys
from pathlib import Path

root = Path(sys.argv[1])
claude = Path(sys.argv[2])


def description(skill_md: Path) -> str:
    text = skill_md.read_text(encoding="utf-8")
    m = re.search(r"^description:[ \t]*([>|][-+]?)?[ \t]*(.*)$", text, re.M)
    d = ""
    if m:
        d = m.group(2).strip().strip("\"'")
        if m.group(1):  # folded/literal block: indented lines that follow
            block = re.match(r"(?:[ \t]+.*\n?)+", text[m.end() + 1:])
            d = " ".join(l.strip() for l in block.group(0).splitlines()) if block else d
    return d if len(d) <= 90 else d[:87] + "..."


def scan(base: Path) -> dict:
    out = {}
    if base.is_dir():
        for p in sorted(base.iterdir()):
            if (p / "SKILL.md").is_file():
                out[p.name] = p
    return out


lock = json.loads((root / "skills-lock.json").read_text()).get("skills", {})
community = scan(root / ".agents" / "skills")
custom = scan(root / "skills")
disk = {**community, **custom}

rows, problems = [], []
for name in sorted(set(lock) | set(disk)):
    if name in custom:
        origin = "custom"
    elif name in lock:
        origin = lock[name]["source"]
    else:
        origin = "?"
    link = claude / name
    if name not in disk:
        state = "not on disk"
    elif not link.is_symlink():
        state = "not linked"
    elif not link.exists():
        state = "dangling"
    else:
        state = "ok"
    if name in lock and name not in disk:
        problems.append(f"{name}: in skills-lock.json but missing on disk (npx skills remove {name})")
    if name in community and name not in lock:
        problems.append(f"{name}: on disk but not in skills-lock.json")
    if state in ("not linked", "dangling"):
        problems.append(f"{name}: {state} in {claude} (run link-agent-config.sh)")
    desc = description(disk[name] / "SKILL.md") if name in disk else ""
    rows.append((name, origin, state, desc))

w = max(len(r[0]) for r in rows)
o = max(len(r[1]) for r in rows)
for name, origin, state, desc in rows:
    print(f"{name:<{w}}  {origin:<{o}}  {state:<11}  {desc}")

for extra in sorted(claude.iterdir()) if claude.is_dir() else []:
    if extra.name not in disk:
        problems.append(f"{extra.name}: in {claude} but not managed by this repo")

print(f"\n{len(rows)} skills ({len(custom)} custom)")
if problems:
    print("\nProblems:")
    for p in problems:
        print(f"  - {p}")
    sys.exit(1)
print("All consistent.")
PY
