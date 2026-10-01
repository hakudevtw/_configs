# 終端機

Shell、命令列工具與執行環境由 [Brewfile](../Brewfile) 和 `scripts/` 安裝；每個工具是什麼、怎麼用，看 [TOOLS.md](TOOLS.md)。

## 手動步驟

- **Homebrew** 本身：https://brew.sh（第一次執行 `./install.sh` 之前）。
- **GitHub 登入**：`gh auth login`。
- **Bitwarden CLI**：`bw login`（怎麼拿來管 token，還沒決定）。
- **Claude Code**：由 `scripts/install-claude-code.sh` 用官方原生安裝程式安裝。不要同時裝 brew cask 或 npm 版。

## 已被取代、新工具確定能用之後就可以移除

`scripts/brew-check.sh` 會列出來並印出移除指令，但不會替你刪。例如：nvm 與 fnm（改用 mise）、spaceship（改用 starship）、npm 全域的 pnpm／yarn（改用 mise）、Docker Desktop（改用 OrbStack）。
