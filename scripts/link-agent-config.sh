#!/usr/bin/env bash
# Link global AI agent config and skills.
#
# Config:  AGENTS.md → ~/.claude/CLAUDE.md
# Skills:  community (.agents/skills/) + custom (skills/) →
#          ~/.agents/skills, ~/.claude/skills,
#          ~/.gemini/antigravity-cli/skills (CLI),
#          ~/.gemini/config/skills (desktop app)
#
# Usage:
#   ./scripts/link-agent-config.sh
#   ./scripts/link-agent-config.sh --no-update

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

COMMUNITY_SKILLS="$AGENT_SKILLS_ROOT/.agents/skills"
CUSTOM_SKILLS="$AGENT_SKILLS_ROOT/skills"
DEST_AGENTS="$HOME/.agents/skills"
DEST_CLAUDE="$HOME/.claude/skills"
DEST_ANTIGRAVITY_CLI="$HOME/.gemini/antigravity-cli/skills"
DEST_ANTIGRAVITY_APP="$HOME/.gemini/config/skills"
LEGACY_GEMINI_SKILLS="$HOME/.gemini/skills"
CLAUDE_DIR="$HOME/.claude"

UPDATE=true
if [ "${1:-}" = "--no-update" ]; then
  UPDATE=false
fi

info "Agent config from $AGENT_SKILLS_ROOT"

# --- Config ---

if [ -L "$CLAUDE_DIR" ]; then
  rm "$CLAUDE_DIR"
fi
mkdir -p "$CLAUDE_DIR"

link_path "$AGENT_SKILLS_ROOT/AGENTS.md" "$CLAUDE_DIR/CLAUDE.md"

# --- Skills ---

if [ "$UPDATE" = true ]; then
  info "Updating community skills (npx skills update)..."
  (cd "$AGENT_SKILLS_ROOT" && npx skills update -y)
else
  warn "Skipping npx skills update (--no-update)"
fi

mkdir -p "$CUSTOM_SKILLS"

info "Linking skills → $DEST_AGENTS"
link_skills_to "$DEST_AGENTS" "$AGENT_SKILLS_ROOT" "$COMMUNITY_SKILLS" "$CUSTOM_SKILLS"

info "Linking skills → $DEST_CLAUDE"
link_skills_to "$DEST_CLAUDE" "$AGENT_SKILLS_ROOT" "$COMMUNITY_SKILLS" "$CUSTOM_SKILLS"

if [ -L "$LEGACY_GEMINI_SKILLS" ]; then
  warn "Removing legacy Gemini CLI skills symlink: $LEGACY_GEMINI_SKILLS"
  rm "$LEGACY_GEMINI_SKILLS"
fi

info "Linking skills → $DEST_ANTIGRAVITY_CLI"
link_skills_to "$DEST_ANTIGRAVITY_CLI" "$AGENT_SKILLS_ROOT" "$COMMUNITY_SKILLS" "$CUSTOM_SKILLS"

info "Linking skills → $DEST_ANTIGRAVITY_APP"
link_skills_to "$DEST_ANTIGRAVITY_APP" "$AGENT_SKILLS_ROOT" "$COMMUNITY_SKILLS" "$CUSTOM_SKILLS"

echo
ok "Agent config linked"
info "Verify in Claude Code: /skills"
info "Verify in Cursor: Settings → Rules → Skills"
info "Verify in Antigravity CLI: agy (slash commands)"
info "Verify in Antigravity app: Agent panel (global skills from ~/.gemini/config/skills)"
