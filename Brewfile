# 共用設定：每台電腦都會安裝。
# scripts/brew-install.sh 會再疊上 Brewfile.<profile> 與 ~/.config/_configs/Brewfile.local。
#
# scripts/brew-check.sh 會讀下面兩種標記（只列出，不會刪除）：
#   brew "新工具"  # 說明 | replaces: 舊工具1 舊工具2    這一項取代了哪些舊工具
#   # obsolete: 舊工具1 舊工具2                         決定不要了的工具
# 名稱可以寫 formula／cask 名、npm:<全域套件>、app:<App 名稱>、path:<資料夾>。
# 每個工具怎麼用：resources/TOOLS.md

# --- 終端機與 Shell ---
cask "ghostty"                  # 終端機（設定：configs/ghostty）
brew "starship"                 # 提示符（設定：configs/starship.toml） | replaces: path:~/.oh-my-zsh/custom/themes/spaceship-prompt
brew "fzf"                      # 模糊搜尋：Ctrl-R 搜歷史、Ctrl-T 選檔案
brew "zoxide"                   # 更聰明的 cd：`z 關鍵字` 跳到你去過的資料夾
cask "font-hack-nerd-font"      # 提示符用的圖示字型
cask "font-maple-mono-nf-cn"
cask "font-victor-mono"
cask "font-fira-code"
brew "zsh-autosuggestions"      # 打字時顯示灰色的歷史建議 | replaces: path:~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
brew "zsh-syntax-highlighting"  # 指令合法或不合法時上色 | replaces: path:~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
# Oh My Zsh 本體由 scripts/install-shell.sh 安裝（不是 Homebrew）。

# --- 命令列 ---
brew "git"                      # 比 Apple 內建的 git 新
brew "gh"                       # GitHub 命令列：PR、issue、登入
brew "lazygit"                  # git 的終端機介面：暫存、分支、commit graph
brew "lazydocker"               # Docker 容器與日誌的終端機介面
brew "git-delta"                # 好讀的 git diff（configs/gitconfig）
brew "eza"                      # 有顏色、圖示、git 狀態的 ls；`eza --tree` 顯示樹狀圖
brew "bat"                      # 有語法上色的 cat
brew "ripgrep"                  # 很快的 grep（指令 `rg`）
brew "fd"                       # 很快的 find
brew "jq"                       # 查詢與格式化 JSON
brew "tree"                     # 目錄樹（保留：agent 和文件會直接呼叫它）
brew "btop"                     # 系統監控 | replaces: htop
brew "duf"                      # 磁碟剩餘空間總覽（取代 df 的顯示）
brew "dust"                     # 哪些資料夾最佔空間（du 的替代品）
brew "tlrc"                     # tldr：簡短的指令範例 | replaces: tldr
brew "lefthook"                 # git hooks 執行器；只有放了 lefthook.yml 的 repo 才會啟用
brew "cloudflared"              # 把 localhost 變成暫時的公開網址： cloudflared tunnel --url http://localhost:3000
brew "mkcert"                   # 本機信任的 HTTPS 憑證
brew "bitwarden-cli"            # `bw`：在終端機讀 Bitwarden 裡的機密
brew "mas"                      # 用命令列裝 Mac App Store 的 app（要先登入 App Store）

# --- 執行環境 ---
# node、pnpm、bun 寫在 configs/mise.toml（版本由 git 管理）
brew "mise"                     # 執行環境版本管理，依 repo 自動切換 Node | replaces: nvm fnm npm:pnpm npm:yarn npm:corepack path:~/.nvm path:~/.local/share/fnm path:~/.bun

# --- 編輯器與 AI ---
cask "cursor"                   # 主要編輯器，外掛清單見 configs/cursor-extensions.txt | replaces: visual-studio-code
cask "claude"                   # Claude 桌面 app（Claude Code 本體：scripts/install-claude-code.sh）
cask "cursor-cli"               # Cursor 的命令列 agent（指令 cursor-agent）| replaces: path:~/.local/bin/cursor-agent
cask "orbstack"                 # 很快的 Docker 與 Linux 虛擬機 | replaces: docker-desktop app:Docker

# --- 日常 app ---
cask "raycast"                  # 啟動器、視窗管理、剪貼簿歷史
cask "google-chrome"
cask "bitwarden"                # 密碼管理器 app
cask "notion"
cask "notion-calendar"
cask "figma"
cask "obsidian"                 # Markdown 筆記
cask "shottr"                   # 截圖，含標註與 OCR（免費版 30 天後會提示付費；考慮買 CleanShot X，見 Brewfile.optional）
cask "karabiner-elements"       # 鍵盤重新對應
cask "scroll-reverser"          # 滑鼠與觸控板分別設定捲動方向
cask "domzilla-caffeine"        # 防止 Mac 休眠
cask "stats"                    # 在選單列顯示 CPU、記憶體、磁碟、網路
cask "alt-tab"                  # Windows 風格、有縮圖的視窗切換器
cask "devutils"                 # 離線工具箱：JSON、Base64、JWT、雜湊、時間戳

# --- 開發用圖形工具 ---
cask "bruno"                    # API 用戶端；collection 是 repo 裡的純文字檔 | replaces: yaak app:Yaak
cask "beekeeper-studio"         # 資料庫圖形介面：Postgres、MySQL、SQLite

# --- Mac App Store ---
mas "LINE", id: 539883307

# --- 決定不要了的 ---
# obsolete: app:Arc app:Desktop-Translator npm:@google/gemini-cli gemini-cli
# obsolete: uv tre-command 4k-video-downloader+ path:~/.local/bin/specify path:~/.local/share/uv/tools/specify-cli
# obsolete: rbenv ruby-build gmp path:~/.rbenv
