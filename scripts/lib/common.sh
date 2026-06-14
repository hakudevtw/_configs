#!/usr/bin/env bash
# Shared helpers for _configs scripts.

GREEN="\033[0;32m"
CYAN="\033[0;36m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

info() { echo -e "${CYAN}$*${RESET}"; }
ok() { echo -e "✅ ${GREEN}$*${RESET}"; }
warn() { echo -e "⚠️  ${YELLOW}$*${RESET}"; }
err() { echo -e "❌ ${RED}$*${RESET}" >&2; }

# Repo root (_configs/) — set when this file is sourced.
CONFIGS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
AGENT_SKILLS_ROOT="$CONFIGS_ROOT/agent-skills"

# Create or refresh dest → src symlink.
link_path() {
  local src=$1
  local dest=$2

  if [ ! -e "$src" ]; then
    err "Source does not exist: $src"
    return 1
  fi

  mkdir -p "$(dirname "$dest")"

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    ok "Already linked $dest → $src"
    return 0
  fi

  ln -sf "$src" "$dest"
  ok "Linked $dest → $src"
}

# Resolve a symlink target to an absolute path (macOS-safe).
resolve_path() {
  local path=$1

  if [ ! -L "$path" ]; then
    printf '%s\n' "$path"
    return
  fi

  local target dir
  target="$(readlink "$path")"
  if [[ "$target" != /* ]]; then
    dir="$(cd "$(dirname "$path")" && pwd)"
    target="$(cd "$dir/$target" 2>/dev/null && pwd || printf '%s/%s' "$dir" "$target")"
  fi
  printf '%s\n' "$target"
}

# Refuse to link into a dest that symlinks back into the repo (would pollute the working copy).
guard_skill_dest() {
  local dest=$1
  local repo_root=$2

  if [ ! -L "$dest" ]; then
    mkdir -p "$dest"
    return
  fi

  local resolved
  resolved="$(resolve_path "$dest")"
  case "$resolved" in
    "$repo_root"|"$repo_root"/*)
      err "$dest is a symlink into this repo ($resolved)."
      err "Remove it (rm \"$dest\") and re-run; the script will recreate it as a real directory."
      exit 1
      ;;
  esac

  mkdir -p "$dest"
}

# Find SKILL.md under search roots and symlink each skill dir into dest.
# Later roots override earlier ones when skill names collide.
link_skills_to() {
  local dest=$1
  local repo_root=$2
  shift 2
  local search_roots=("$@")

  guard_skill_dest "$dest" "$repo_root"

  local count=0
  local root skill_md src name target

  for root in "${search_roots[@]}"; do
    [ -d "$root" ] || continue

    while IFS= read -r -d '' skill_md; do
      src="$(dirname "$skill_md")"
      name="$(basename "$src")"
      target="$dest/$name"

      if [ -e "$target" ] && [ ! -L "$target" ]; then
        rm -rf "$target"
      fi

      ln -sfn "$src" "$target"
      ok "linked $name → $src ($dest)"
      count=$((count + 1))
    done < <(
      find "$root" -name SKILL.md \
        -not -path '*/node_modules/*' \
        -not -path '*/deprecated/*' \
        -print0
    )
  done

  if [ "$count" -eq 0 ]; then
    warn "No skills found under: ${search_roots[*]}"
  fi
}
