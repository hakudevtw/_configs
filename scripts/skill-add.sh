#!/usr/bin/env bash
# Add a community skill to this repo from anywhere, then re-link.
# Arguments are passed to `npx skills add`.
#
# Usage: skill-add.sh owner/repo --skill name
#        skill-add.sh owner/repo --list          # browse without installing

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

if [ "$#" -eq 0 ]; then
  err "usage: skill-add.sh owner/repo --skill name"
  exit 1
fi

(cd "$AGENT_SKILLS_ROOT" && npx skills add "$@")

case " $* " in
  *" --list "*|*" -l "*) exit 0 ;;
esac

"$SCRIPT_DIR/link-agent-config.sh"
echo
info "Review and commit: cd $CONFIGS_ROOT && git status"
