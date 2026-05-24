#!/bin/bash

# Colors
GREEN="\033[0;32m"
CYAN="\033[0;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"

echo -e "${CYAN}🚀 Running install.sh...${RESET}"

# Spinner animation for background process
spinner() {
  local pid=$1
  local delay=0.1
  local spin='|/-\'
  while kill -0 $pid 2>/dev/null; do
    for i in $(seq 0 3); do
      printf "\r${YELLOW}⚙️  ${spin:$i:1}${RESET}"
      sleep $delay
    done
  done
  printf "\r"
}

# Link a file or directory symlink
link_file() {
  src=$1
  dest=$2
  mkdir -p "$(dirname "$dest")"
  ln -sf "$src" "$dest"
  echo -e "✅ Linked ${GREEN}$dest${RESET} → ${CYAN}$src${RESET}"
}

# Link a directory — ensures src exists and avoids self-referential loops
link_dir() {
  src=$1
  dest=$2

  if [ -L "$src" ]; then
    echo -e "❌ Refusing to link: ${CYAN}$src${RESET} is already a symlink"
    exit 1
  fi

  mkdir -p "$src"

  # Remove a self-referential symlink if one was accidentally created inside src
  if [ -L "$src/.claude" ] && [ "$(readlink "$src/.claude")" = "$src" ]; then
    rm "$src/.claude"
    echo -e "⚠️  Removed self-referential symlink at ${CYAN}$src/.claude${RESET}"
  fi

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo -e "✅ Already linked ${GREEN}$dest${RESET} → ${CYAN}$src${RESET}"
    return
  fi

  link_file "$src" "$dest"
}

# Zsh -------------------------------
link_file "$HOME/_configs/configs/zshrc" "$HOME/.zshrc"
link_file "$HOME/_configs/configs/spaceship.zsh" "$HOME/.config/spaceship.zsh"

# Ghostty ---------------------------
link_file "$HOME/_configs/configs/ghostty" "$HOME/.config/ghostty/config"
link_file "$HOME/_configs/configs/ghostty" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

# Claude Code & AI agents -----------------------
AGENTS="$HOME/_configs/agents"

# ~/.claude is a directory with symlinks inside (not a single symlink)
if [ -L "$HOME/.claude" ]; then
  rm "$HOME/.claude"
fi
mkdir -p "$HOME/.claude"

link_file "$AGENTS/AGENTS.md" "$HOME/.claude/CLAUDE.md"
link_file "$AGENTS/claude/settings.json" "$HOME/.claude/settings.json"

# Skills — one source, all agent tools
SKILL_TARGETS=(
  "$HOME/.agents/skills"
  "$HOME/.claude/skills"
  "$HOME/.cursor/skills"
  "$HOME/.gemini/skills"
  "$HOME/.codex/skills"
)
for target in "${SKILL_TARGETS[@]}"; do
  link_dir "$AGENTS/skills" "$target"
done

link_file "$HOME/_configs/configs/claude-code-router.config.json" "$HOME/.claude-code-router/config.json"

echo -e "${GREEN}✨ All links created successfully!${RESET}"

# Linux
alias ll='ls -latr'

# Github spec-kit
# https://github.com/github/spec-kit?tab=readme-ov-file#-get-started
# brew install uv
# uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
# echo -e "${GREEN}✨ Specify-cli installed successfully!${RESET}"
