#!/usr/bin/env bash
# Update community skills, show what changed upstream, then re-link.
# Nothing is committed: review the diff, then commit or `git restore` it.
#
# Usage: skill-update.sh [skill ...]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

(cd "$AGENT_SKILLS_ROOT" && npx skills update -y "$@")

echo
info "Changed skills (vs. last commit):"
git -C "$CONFIGS_ROOT" status --short -- agent-skills/.agents agent-skills/skills-lock.json
echo
info "Full diff: git -C $CONFIGS_ROOT diff -- agent-skills/.agents"

"$SCRIPT_DIR/link-agent-config.sh"
