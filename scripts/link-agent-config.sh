#!/usr/bin/env bash
# Link global Claude Code config and skills.
#
# Config:  AGENTS.md → ~/.claude/CLAUDE.md, settings.json → ~/.claude/settings.json,
#          hooks/ → ~/.claude/hooks
# MCP:     mcp.json (+ machine overlay) → ~/.claude.json & Claude Desktop config
# Skills:  community (.agents/skills/) + custom (skills/) → ~/.claude/skills
#
# Updating community skills is a separate, reviewed step: scripts/skill-update.sh
#
# Usage: ./scripts/link-agent-config.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

COMMUNITY_SKILLS="$AGENT_SKILLS_ROOT/.agents/skills"
CUSTOM_SKILLS="$AGENT_SKILLS_ROOT/skills"
DEST_CLAUDE="$HOME/.claude/skills"
CLAUDE_DIR="$HOME/.claude"

info "Agent config from $AGENT_SKILLS_ROOT"

# --- Config ---

if [ -L "$CLAUDE_DIR" ]; then
  rm "$CLAUDE_DIR"
fi
mkdir -p "$CLAUDE_DIR"

link_path "$AGENT_SKILLS_ROOT/AGENTS.md" "$CLAUDE_DIR/CLAUDE.md"
link_path "$AGENT_SKILLS_ROOT/settings.json" "$CLAUDE_DIR/settings.json"
link_path "$AGENT_SKILLS_ROOT/hooks" "$CLAUDE_DIR/hooks"

# --- MCP ---

"$SCRIPT_DIR/sync-mcp-config.sh"

# --- Skills ---

mkdir -p "$CUSTOM_SKILLS"

info "Linking skills → $DEST_CLAUDE"
link_skills_to "$DEST_CLAUDE" "$AGENT_SKILLS_ROOT" "$COMMUNITY_SKILLS" "$CUSTOM_SKILLS"
prune_dangling_links "$DEST_CLAUDE" "$AGENT_SKILLS_ROOT"

echo
ok "Agent config linked"
info "Verify in Claude Code: /skills"
info "Inventory and consistency check: scripts/list-skills.sh"
