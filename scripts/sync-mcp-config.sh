#!/usr/bin/env bash
# Sync MCP servers → Claude Code (~/.claude.json) and Claude Desktop.
#
# Sources (later wins on name clash):
#   agent-skills/mcp.json                  base config, in git
#   ~/.config/_configs/mcp.local.json      machine overlay, not in git (optional)
#
# Merges into top-level mcpServers: servers listed above are added or updated,
# any other server already in the targets is left untouched. Removing a server
# from the sources does not remove it from the targets (use `claude mcp remove`).
# Per-project servers in ~/.claude.json (projects.*.mcpServers) are untouched.
# Reference secrets as ${VAR} (value lives in the machine overlay local.zsh).
#
# Usage: ./scripts/sync-mcp-config.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

MCP_SOURCE="$AGENT_SKILLS_ROOT/mcp.json"
MCP_LOCAL="$HOME/.config/_configs/mcp.local.json"
CLAUDE_JSON="$HOME/.claude.json"
DESKTOP_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"

if [ ! -f "$MCP_SOURCE" ]; then
  err "MCP source not found: $MCP_SOURCE"
  exit 1
fi

info "Syncing MCP from $MCP_SOURCE"
[ -f "$MCP_LOCAL" ] && info "Including machine overlay $MCP_LOCAL"

python3 - "$MCP_SOURCE" "$MCP_LOCAL" "$CLAUDE_JSON" "$DESKTOP_CONFIG" <<'PY'
import json
import sys
from pathlib import Path


def load_json(path: Path) -> dict:
    if not path.exists():
        return {}
    with path.open(encoding="utf-8") as f:
        return json.load(f)


def save_json(path: Path, data: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)
        f.write("\n")


def normalize_servers(servers: dict) -> dict:
    """Ensure stdio servers have an explicit type for Claude Desktop."""
    normalized = {}
    for name, cfg in servers.items():
        entry = dict(cfg)
        if "command" in entry and "type" not in entry:
            entry["type"] = "stdio"
        normalized[name] = entry
    return normalized


def merge_into(path: Path, servers: dict) -> None:
    data = load_json(path)
    existing = data.get("mcpServers", {})
    unmanaged = sorted(set(existing) - set(servers))
    data["mcpServers"] = {**existing, **servers}
    save_json(path, data)
    print(f"wrote {path}")
    if unmanaged:
        print(f"  left untouched: {', '.join(unmanaged)}")


source_path = Path(sys.argv[1])
local_path = Path(sys.argv[2])
claude_path = Path(sys.argv[3])
desktop_path = Path(sys.argv[4])

source = load_json(source_path)
if "mcpServers" not in source:
    print(f"error: {source_path} must contain an mcpServers object", file=sys.stderr)
    sys.exit(1)

servers = dict(source["mcpServers"])
servers.update(load_json(local_path).get("mcpServers", {}))
servers = normalize_servers(servers)
print(f"servers: {', '.join(sorted(servers)) if servers else '(none)'}")

merge_into(claude_path, servers)
merge_into(desktop_path, servers)

with_vars = sorted(n for n, c in servers.items() if "${" in json.dumps(c))
if with_vars:
    print(
        f"note: {', '.join(with_vars)} use ${{VAR}}; Claude Code expands it from the "
        "shell env it was started from, Claude Desktop does not",
        file=sys.stderr,
    )
PY

ok "MCP synced to Claude Code and Claude Desktop"
info "Verify: claude mcp list"
info "Verify: restart Claude Desktop, then check Settings → Developer → MCP"
