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

# Link function
link_file() {
  src=$1
  dest=$2
  mkdir -p "$(dirname "$dest")"
  ln -sf "$src" "$dest"
  echo -e "✅ Linked ${GREEN}$dest${RESET} → ${CYAN}$src${RESET}"
}

# Zsh -------------------------------
link_file "$HOME/_config/zshrc" "$HOME/.zshrc"

# Ghostty ---------------------------
# XDG config path
link_file "$HOME/_config/ghostty/config" "$HOME/.config/ghostty/config"

echo -e "${GREEN}✨ All links created successfully!${RESET}"
