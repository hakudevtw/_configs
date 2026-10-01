# 工具說明書：每個工具是什麼、怎麼用

全部由 [Brewfile](../Brewfile) 安裝。每個工具一列：它是什麼、第一步可以試什麼、官方文件在哪。
多數終端機工具用 `--help` 或在程式裡按 `?` 就能看到最新的說明。標示「未驗證」的是憑記憶寫的，使用前請以官方文件為準。

## 終端機與 Shell

| 工具 | 是什麼 | 先試試看 | 文件 |
|------|--------|---------|------|
| Ghostty | 終端機，設定在 `configs/ghostty` | `Cmd+,` 開設定檔 | [文件](https://ghostty.org/docs) |
| Oh My Zsh | Zsh 框架（例如 `git` 縮寫指令） | `alias \| grep git` 看有哪些 git 縮寫 | [repo](https://github.com/ohmyzsh/ohmyzsh) |
| Starship | 提示符，設定在 `configs/starship.toml` | 改 toml 後開新分頁 | [設定](https://starship.rs/config/) |
| zsh-autosuggestions | 打字時從歷史顯示灰色建議 | 按 `→` 接受 | [repo](https://github.com/zsh-users/zsh-autosuggestions) |
| zsh-syntax-highlighting | 指令不合法時顯示紅色 | 直接打字就會看到 | [repo](https://github.com/zsh-users/zsh-syntax-highlighting) |
| fzf | 模糊搜尋 | `Ctrl-R` 搜歷史、`Ctrl-T` 選檔案、`Alt-C` 切換資料夾 | [repo](https://github.com/junegunn/fzf) |
| zoxide | 會學習你常去資料夾的 `cd` | `z proj` 跳到最常用、名稱含 proj 的資料夾；`zi` 互動式選擇 | [repo](https://github.com/ajeetdsouza/zoxide) |

## Git 與 GitHub

| 工具 | 是什麼 | 先試試看 | 文件 |
|------|--------|---------|------|
| gh | GitHub 命令列 | `gh auth login`、`gh pr create`、`gh pr view --web`、`gh pr checks` | [手冊](https://cli.github.com/manual/) |
| lazygit | git 的終端機介面 | 看下面的 lazygit 五分鐘教學 | [repo](https://github.com/jesseduffield/lazygit) |
| git-delta | 好讀的 diff。連結 `configs/gitconfig` 之後，`git diff`、`git log -p` 會自動使用 | 在 diff 裡按 `n`／`N` 跳到下一個／上一個檔案 | [文件](https://dandavison.github.io/delta/) |
| lefthook | git hooks 執行器，只有放了 `lefthook.yml` 的 repo 才會啟用 | 在那樣的 repo 裡執行 `lefthook install` | [文件](https://lefthook.dev/) |

### lazygit 五分鐘教學

在 repo 裡執行 `lazygit`。隨時按 `?` 可以看目前面板的按鍵清單；下面的按鍵來自專案文件，之後可能變動，以 `?` 為準。

- 面板有編號：`1` 狀態、`2` 檔案、`3` 分支、`4` Commits、`5` Stash。按數字跳過去。
- 檔案面板：`space` 暫存／取消暫存單一檔案、`a` 全部暫存、`c` commit、`d` 捨棄修改。
- 分支面板：`space` 切換分支、`n` 建立新分支。
- Commits 面板：顯示 commit 列表。**把面板放大（按 `+`）就會出現分支圖（graph）**（預設設定是 `log.showGraph: when-maximised`；想一直顯示可以在 lazygit 設定裡改成 `always`）。對某個 commit 按 `enter` 可以看它改了哪些檔案。
- `P` push、`p` pull、`q` 離開。
- 只想看 graph：`lazygit log`，或不用 lazygit 的 `git log --graph --oneline --all --decorate`。

## 舊指令的現代替代品

| 工具 | 取代 | 先試試看 | 文件 |
|------|------|---------|------|
| eza | `ls`、`tree` | `eza -l --git`、`eza --tree --level=2 --git-ignore` | [repo](https://github.com/eza-community/eza) |
| bat | `cat` | `bat file.ts`、`bat -p file`（不顯示行號） | [repo](https://github.com/sharkdp/bat) |
| ripgrep | `grep -r` | `rg "文字"`、`rg -t ts "文字"`、`rg -l "文字"`（只列檔名） | [指南](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md) |
| fd | `find` | `fd 名稱`、`fd -e ts`（依副檔名） | [repo](https://github.com/sharkdp/fd) |
| jq | 手動讀 JSON | `jq . file.json`、`jq '.a.b' file.json` | [手冊](https://jqlang.org/manual/) |
| btop | `top`、`htop` | `btop`，按 `q` 離開 | [repo](https://github.com/aristocratos/btop) |
| duf | `df` | `duf` | [repo](https://github.com/muesli/duf) |
| dust | `du` | `dust -d 2`（只看兩層） | [repo](https://github.com/bootandy/dust) |
| tlrc | 簡短的 `man` | `tldr tar` | [repo](https://github.com/tldr-pages/tlrc) |
| tree | | `tree -L 2`（保留它，因為 agent 和文件會直接呼叫） | |

`eza`、`bat` 刻意不用 alias 蓋掉 `ls`、`cat`：alias 可能改變 Claude Code 解析的輸出格式。請自己打新名字。

## 執行環境：mise

Node、pnpm、bun 的版本寫在 `configs/mise.toml`（連結到 `~/.config/mise/config.toml`）。

- `mise ls` 看目前生效的版本，`mise doctor` 做健康檢查。
- 進入有 `mise.toml`、`.tool-versions`、`.nvmrc` 或 `.node-version` 的 repo，Node 會自動切換。`.nvmrc` 能用是因為 `configs/mise.toml` 為 node 打開了這個功能（已用實際程式驗證）。
- 版本還沒裝時，第一次執行該工具（`mise x`，或找不到指令時）才會安裝；單純 `cd` 不會裝。`mise install` 會一次裝完所有宣告的版本。
- 只為某個 repo 固定版本：`mise use node@22`（會寫出 `mise.toml`）。文件：[mise.jdx.dev](https://mise.jdx.dev/)。
- 刻意不全域安裝 yarn：專案需要時再在那個專案裡加。

## 網路與機密

| 工具 | 是什麼 | 先試試看 | 文件 |
|------|--------|---------|------|
| cloudflared | 把 localhost 變成暫時的公開網址，不用帳號 | `cloudflared tunnel --url http://localhost:3000` | [文件](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/) |
| mkcert | 本機信任的 HTTPS 憑證 | `mkcert -install`，然後 `mkcert localhost` | [repo](https://github.com/FiloSottile/mkcert) |
| Bitwarden CLI（`bw`） | 在終端機讀 Bitwarden 裡的機密 | `bw login`、`bw unlock`、`bw list items --search 名稱`（怎麼拿來管 token：還沒決定） | [文件](https://bitwarden.com/help/cli/) |
| mas | 用命令列裝 Mac App Store 的 app | `mas list`、`mas install <id>`（要先登入 App Store） | [repo](https://github.com/mas-cli/mas) |

用手機看開發中的網站：手機和 Mac 連同一個 Wi-Fi，開 `http://<Mac 的 IP>:3000`（Next.js 啟動時會印出 Network 網址）。不同網路或需要 HTTPS 時，用 cloudflared。

## App

| App | 是什麼 | 備註 | 文件 |
|-----|--------|------|------|
| Raycast | 啟動器、視窗管理、剪貼簿歷史 | 預設 `Option+Space` | [手冊](https://manual.raycast.com/) |
| Cursor／VS Code | 編輯器 | Cursor 有 AI 功能 | [cursor.com](https://cursor.com/docs) |
| Claude | 聊天與 Code 分頁的桌面 app | Claude Code 本體由 `scripts/install-claude-code.sh` 安裝 | [文件](https://code.claude.com/docs) |
| OrbStack | Docker 與 Linux 虛擬機 | 安裝後 `docker` 指令就能用；想要介面用 `lazydocker` | [文件](https://docs.orbstack.dev/) |
| Bitwarden | 密碼管理器 app | | [說明](https://bitwarden.com/help/) |
| Bruno | API 用戶端，collection 是 repo 裡的純文字檔 | 開一個資料夾當 collection，再 commit | [文件](https://docs.usebruno.com/) |
| Beekeeper Studio | 資料庫圖形介面（Postgres、MySQL、SQLite） | | [文件](https://docs.beekeeperstudio.io/) |
| Obsidian | Markdown 筆記 | vault 其實就是一個資料夾 | [說明](https://help.obsidian.md/) |
| Shottr | 截圖，含標註與 OCR 文字辨識；免費版 30 天後會提示付費 | 不能錄影，錄影用 macOS 內建的 `Cmd+Shift+5`；考慮買 CleanShot X（見 `Brewfile.optional`） | [shottr.cc](https://shottr.cc/) |
| Stats | 在選單列顯示 CPU、記憶體、網路 | 點圖示看詳細 | [repo](https://github.com/exelban/stats) |
| AltTab | 有縮圖的視窗切換器 | 預設 `Option+Tab` | [alt-tab.app](https://alt-tab.app/) |
| DevUtils | 離線工具箱：JSON、Base64、JWT、雜湊、時間戳 | | [devutils.com](https://devutils.com/) |
| Karabiner-Elements | 鍵盤重新對應 | 設定在 `~/.config/karabiner`（還沒同步） | [文件](https://karabiner-elements.pqrs.org/docs/) |
| Scroll Reverser | 滑鼠與觸控板分別設定捲動方向 | | [pilotmoon.com](https://pilotmoon.com/scrollreverser/) |
| Caffeine | 防止 Mac 休眠 | 點選單列的杯子 | |
| Notion、Notion Calendar、Figma | 工作工具 | | |
| Slack、Linear | 公司 profile | | |
| Discord、NordVPN、IINA | 個人 profile | | |

## 這個 repo 的 Claude Code 設定

見 [README](../README.md)：skills（`skill-list`、`skill-add`、`skill-update`）、安全守衛 hook、通知、狀態列。
