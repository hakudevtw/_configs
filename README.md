# Haku 的 MacBook 設定

個人 dotfiles 與 AI agent 設定，用來在新的 Mac（公司、個人）上快速還原同一套環境。

## 快速開始

新電腦：

```bash
# 1. 先安裝 Homebrew：https://brew.sh
# 2. 告訴這台電腦它的 profile（work 或 personal）
mkdir -p ~/.config/_configs && echo work > ~/.config/_configs/profile

git clone <repo-url> ~/_configs
cd ~/_configs
./install.sh
```

接著照 [手動安裝](#手動安裝)、[登入與 Token 清單](#登入與-token-清單)、[機密與每台電腦的差異](#機密與每台電腦的差異) 完成剩下的部分。

`install.sh` 只是依序執行 `scripts/` 裡的腳本。只想更新某一塊時，直接單獨執行對應的腳本。

## 目錄結構

```
_configs/
├── install.sh              # 依序執行所有安裝與連結腳本
├── Brewfile*               # App 與命令列工具（共用、依 profile、選用）
├── scripts/                # 單一用途的自動化腳本
├── configs/                # Shell、終端機、git、mise 設定
├── agent-skills/           # [Agent Skills](agent-skills/README.md)
│   ├── AGENTS.md           # 全域規則 → ~/.claude/CLAUDE.md
│   ├── mcp.json            # 全域 MCP server（由 link-agent-config.sh 同步）
│   ├── settings.json       # Claude Code 設定 → ~/.claude/settings.json
│   ├── hooks/              # 危險指令守衛、狀態列 → ~/.claude/hooks
│   ├── .agents/skills/     # 社群 skills（npx skills + skills-lock.json）
│   ├── skills/             # 自己寫的 skills
│   └── skills-lock.json    # 社群 skills 的鎖定版本
├── docs/adr/               # 重大決定的記錄
└── resources/              # TOOLS.md（每個工具怎麼用）與設定清單
```

## 腳本

一個腳本對應一個功能領域，不是一個 app 一個腳本。

| 腳本 | 功能 |
|------|------|
| `install.sh` | 依序執行下面所有腳本 |
| `scripts/brew-install.sh` | 依這台電腦的 profile 安裝 Brewfile 裡的 app 與工具（`--dry-run` 先預覽） |
| `scripts/brew-check.sh` | 列出 Brewfile 標記為「已被取代／不要了」但還裝著的東西；加 `--apply` 會一項一項問你要不要刪 |
| `scripts/install-shell.sh` | Oh My Zsh |
| `scripts/install-claude-code.sh` | Claude Code（官方原生安裝程式） |
| `scripts/lazygit-sandbox.sh` | 建立練習 lazygit 用的 repo（分支、squash、cherry-pick、會衝突的 rebase） |
| `scripts/link-terminal-config.sh` | Shell（zsh、starship、mise）、git（delta）、終端機（Ghostty） |
| `scripts/link-agent-config.sh` | Claude Code：全域規則、MCP、設定、hooks、skills |
| `scripts/skill-add.sh`・`skill-update.sh`・`list-skills.sh` | 管理社群 skills（alias：`skill-add`、`skill-update`、`skill-list`） |

## App 與命令列工具（Homebrew）

| 檔案 | 何時安裝 | 內容 |
|------|---------|------|
| `Brewfile` | 每台電腦 | 共用的部分 |
| `Brewfile.personal` | profile 是 `personal` | 只在個人電腦裝的 app |
| `Brewfile.work` | profile 是 `work` | 只在公司電腦裝的 app（Slack、Linear） |
| `Brewfile.optional` | 不會自動安裝 | 想試試看或視情況而定的東西，每一項都附說明 |
| `~/.config/_configs/Brewfile.local` | 只有這台電腦，不進 git | 這台額外要裝的 |

profile 就是 `~/.config/_configs/profile` 裡的那個字。`scripts/brew-install.sh` 會把檔案疊起來、接手（adopt）你手動裝過的 app、最後執行 `mise install`。

Brewfile 的某一行可以加上 `| replaces: 舊工具`。新工具裝好之後，`scripts/brew-check.sh` 會告訴你舊的可以移除。`# obsolete: 名稱` 則是「決定不要了」的東西。名稱可以寫 formula／cask 名、`npm:套件名`、`app:App 名稱`、`path:路徑`。

每個工具怎麼用：[resources/TOOLS.md](resources/TOOLS.md)。

## 整頓一台已經在用的電腦（例如家裡那台）

照順序做，每一步確認沒問題再往下，**舊工具最後才刪**：

1. `cd ~/_configs && git pull`，然後 `mkdir -p ~/.config/_configs && echo personal > ~/.config/_configs/profile`。
2. 用 **Ghostty** 操作（不要用 Claude 裡的終端機）。先到「系統設定 → 隱私權與安全性 → App 管理」把 **Ghostty 打開**，Homebrew 才能接手你手動裝過的 app。
3. `./scripts/brew-install.sh --dry-run` 預覽會裝什麼，確認後 `./scripts/brew-install.sh`。過程會要系統密碼；有失敗的項目，再跑一次就會補裝。
4. `./scripts/link-terminal-config.sh`（或整套 `./install.sh`），連結 zsh、starship、mise、git 設定。
5. 開一個**全新的終端機分頁**驗證：提示符、`node -v`、`Ctrl-R`（按住 control 再按 R）、灰色建議。
6. `./scripts/brew-check.sh` 看哪些舊工具可以刪，確定後 `./scripts/brew-check.sh --apply`，它會一項一項問你：app 丟進垃圾桶（可還原），資料夾是永久刪除。
7. 以下幾項要你自己先確認再刪：
   - **Docker Desktop**：裡面如果有要留的容器或資料庫，先 `orb docker migrate`。`--apply` 刪它時要你輸入一句確認文字。
   - **Yaak**：請求先匯入 Bruno。
   - **Arc**：書籤和空間在 `~/Library/Application Support/Arc`，刪 app 不會清掉它。
8. 如果還剩 root 擁有的殘留（以前用 `sudo npm install -g` 裝的），`--apply` 會問你要不要用 `sudo` 刪。

## 手動安裝

下面這些 `brew bundle` 做不到，需要你自己來：

- **Homebrew**：在 `install.sh` 之前先裝。
- **App Store 登入**：`mas` 要先登入才能裝 LINE。
- **Claude Code**：`install.sh` 會用官方安裝程式裝，它會自己更新。不要同時裝 brew cask 或 npm 版。
- **Google Antigravity／Antigravity CLI／Gemini app**：沒有套件，要自己下載（選用，見 `Brewfile.optional`）。
- **Karabiner 設定**：`configs/karabiner.json` 是用「複製」的（新電腦第一次由 `link-terminal-config.sh` 複製），不是 symlink，因為 Karabiner 的圖形介面存檔時會把 symlink 換成一般檔案。在圖形介面改完設定後，把 `~/.config/karabiner/karabiner.json` 複製回 `configs/karabiner.json` 再 commit。它只接管外接鍵盤、忽略內建鍵盤，原因見 [resources/TOOLS.md](resources/TOOLS.md)。
- **系統設定**：[resources/SYSTEM_SETTINGS.md](resources/SYSTEM_SETTINGS.md)。

## 登入與 Token 清單

### A. 登入一次就好（不用環境變數，也不會進 repo）

| 項目 | 怎麼做 | 憑證存在哪 |
|------|--------|-----------|
| GitHub（`gh`） | `gh auth login`，選 GitHub.com、HTTPS、用瀏覽器登入 | macOS 鑰匙圈 |
| Figma MCP | 在 Claude Code 輸入 `/mcp`，選 figma 後授權（OAuth，瀏覽器登入） | 由 Claude Code 保管 |
| Figma 桌面 app | 登入 Figma 帳號 | app 自己 |
| Claude Code／Claude 桌面 app | 第一次執行時登入 | Claude 自己 |
| Bitwarden | 桌面 app 登入；命令列 `bw login`，`bw unlock` 會給一個暫時的 session key | app／暫時 |
| 其他 app | Raycast、Cursor、Notion、Notion Calendar、Slack、Linear、NordVPN、Discord、LINE、Chrome 同步、App Store | 各 app 自己 |

目前不需要登入的 MCP：`chrome-devtools`、`excalidraw`。

### B. 需要放進環境變數的 Token（`local.zsh`）

**目前 repo 裡沒有任何設定需要。** 未來新增的 MCP 或工具需要時，才加進下一節的 `local.zsh`。典型例子是公司私有 npm registry 的 token（放 `~/.npmrc`，不進 repo）。

## 機密與每台電腦的差異

這個 repo 裡的一切都是所有 Mac 共用的**共用設定**。Token 與每台電腦不同的東西，放在 repo 外面的**機器 overlay**：

```bash
mkdir -p ~/.config/_configs
cp configs/local.zsh.example ~/.config/_configs/local.zsh
chmod 600 ~/.config/_configs/local.zsh
$EDITOR ~/.config/_configs/local.zsh   # 加上：export MY_SERVICE_TOKEN="..."
```

- `~/.zshrc` 最後會載入 `local.zsh`，所以每個新終端機都有這些變數。
- 設定檔只寫變數**名稱**（例如 MCP 設定裡的 `${MY_SERVICE_TOKEN}`），絕不寫值。
- 變數名稱自己取。Claude Code 在遠端 MCP 的 `url`／`headers` 裡會把常見名稱（`ANTHROPIC_API_KEY`、`NPM_TOKEN` 等）換成空字串。
- **從 Dock／Spotlight 開的 app 不會載入 `~/.zshrc`**，看不到這些變數。請從終端機啟動 Claude Code（或 Claude Desktop），否則 token 會是空的。
- `local.zsh` 是純文字（權限 600），已被 gitignore，也已列入 Claude 的 `permissions.deny`，Claude 讀不到它。
- 另外每台電腦有自己的 `profile`、`Brewfile.local`、`mcp.local.json`，都放在同一個資料夾。

## Agent 設定總覽

這個 repo 只針對 Claude Code（以及 MCP 用的 Claude Desktop）。

| 設定 | Claude 的位置 | 在這個 repo |
|------|--------------|------------|
| 全域規則 | `~/.claude/CLAUDE.md` | `agent-skills/AGENTS.md`（symlink） |
| Skills | `~/.claude/skills/` | `agent-skills/.agents/skills/`（社群）＋`agent-skills/skills/`（自訂） |
| MCP | `~/.claude.json`、Claude Desktop 設定 | `agent-skills/mcp.json` 由 `sync-mcp-config.sh` 合併進去；每台電腦專屬的放 `~/.config/_configs/mcp.local.json` |
| 專案規則 | 各專案的 `CLAUDE.md` | 由各專案自己管 |
| 設定 | `~/.claude/settings.json` | `agent-skills/settings.json`（symlink） |
| Hooks | `~/.claude/hooks/` | `agent-skills/hooks/`（symlink） |
| OAuth／登入狀態 | `~/.claude.json` | 留在各台電腦上 |

### 安全守衛

`settings.json` 禁止 Claude 讀取 `.env*`、`~/.ssh`、`~/.aws`、`~/.npmrc`、`local.zsh`，並且在每次執行 Bash 前先跑 `hooks/guard-bash.py`：

- **直接拒絕**：對 `/`、`~`、`$HOME` 做遞迴 `rm`；force push 到 `main`／`master`
- **先問你**：`git reset --hard`、`git clean -f`、force push 到其他分支

它看的是指令文字（會穿透 `sudo`、`bash -c`、`$(...)`），所以只是防呆，不是資安邊界：自己寫程式去刪東西是攔不到的。hook 本身出錯時，會改成「先問你」。

另外還有：權限確認時的通知（`Glass`／`Ping` 音效）、狀態列（模型、目錄、分支、context %、5 小時額度）、14 個唯讀 MCP 工具的預先放行。

### 管理 skills

社群 skills 透過 `npx skills` 從 GitHub 安裝，版本鎖定在 `agent-skills/skills-lock.json`。自己寫的放 `agent-skills/skills/<名稱>/SKILL.md`，同名時自己的優先。為什麼鎖版本而不用 plugin：[docs/adr/0001-pin-skills-with-lockfile.md](docs/adr/0001-pin-skills-with-lockfile.md)。

```bash
skill-add owner/repo --skill name   # 任何目錄都能跑：裝進 repo 並重新連結
skill-add owner/repo --list         # 只瀏覽某個 repo，不安裝
skill-update                        # 更新所有社群 skills、列出變動、重新連結
skill-list                          # 清單，並檢查 lock／repo／~/.claude/skills 是否一致
```

這些指令不會替你 commit。Skills 是 Claude 會照著執行的指令，所以 `skill-update` 之後請先看 diff（`git diff -- agent-skills/.agents`），再決定 commit 或 `git restore`。自己寫的 skill：建好 `SKILL.md` 後執行 `scripts/link-agent-config.sh`。

## 其他文件

- [resources/TOOLS.md](resources/TOOLS.md)：每個工具是什麼、怎麼用、官方文件連結
- [Agent Skills](agent-skills/README.md)：skills 的說明
- [App 清單](resources/APPLICATIONS.md)：Brewfile 以外的 app
- [終端機](resources/TERMINAL.md)：手動步驟
- [系統設定](resources/SYSTEM_SETTINGS.md)：macOS 設定檢查表
- [字型](resources/FONTS.md)
- [GLOSSARY.md](GLOSSARY.md)：這個 repo 的用詞定義（給 Claude 讀，英文）

## 外部文件

- [skills.sh](https://skills.sh/)：社群 skills 目錄
- [npx skills CLI](https://github.com/vercel-labs/skills)
- [Claude Code 設定](https://code.claude.com/docs/en/settings)・[skills](https://code.claude.com/docs/en/skills)・[plugins](https://code.claude.com/docs/en/plugins)・[hooks](https://code.claude.com/docs/en/hooks)
- [Agent Skills 標準](https://agents.md/)
