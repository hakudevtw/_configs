# 工具說明書：每個工具是什麼、怎麼用

全部由 [Brewfile](../Brewfile) 安裝。每個工具一列：它是什麼、第一步可以試什麼、官方文件在哪。
多數終端機工具用 `--help` 或在程式裡按 `?` 就能看到最新的說明。標示「未驗證」的是憑記憶寫的，使用前請以官方文件為準。

## 終端機與 Shell


| 工具                      | 是什麼                             | 先試試看                                    | 文件                                                           |
| ----------------------- | ------------------------------- | --------------------------------------- | ------------------------------------------------------------ |
| Ghostty                 | 終端機，設定在 `configs/ghostty`       | `Cmd+,` 開設定檔                            | [文件](https://ghostty.org/docs)                               |
| Oh My Zsh               | Zsh 框架（例如 `git` 縮寫指令）           | `alias \| grep git` 看有哪些 git 縮寫           | [repo](https://github.com/ohmyzsh/ohmyzsh)                   |
| Starship                | 提示符，設定在 `configs/starship.toml` | 改 toml 後開新分頁                            | [設定](https://starship.rs/config/)                            |
| zsh-autosuggestions     | 打字時從歷史顯示灰色建議                    | 按 `→` 接受                                | [repo](https://github.com/zsh-users/zsh-autosuggestions)     |
| zsh-syntax-highlighting | 指令不合法時顯示紅色                      | 直接打字就會看到                                | [repo](https://github.com/zsh-users/zsh-syntax-highlighting) |
| fzf                     | 模糊搜尋                            | `Ctrl-R` 搜歷史、`Ctrl-T` 選檔案、`Alt-C` 切換資料夾 | [repo](https://github.com/junegunn/fzf)                      |
| zoxide                  | 會學習你常去資料夾的 `cd`                 | `z proj` 跳到最常用、名稱含 proj 的資料夾；`zi` 互動式選擇 | [repo](https://github.com/ajeetdsouza/zoxide)                |




## Git 與 GitHub


| 工具        | 是什麼                                                              | 先試試看                                                             | 文件                                               |
| --------- | ---------------------------------------------------------------- | ---------------------------------------------------------------- | ------------------------------------------------ |
| gh        | GitHub 命令列                                                       | `gh auth login`、`gh pr create`、`gh pr view --web`、`gh pr checks` | [手冊](https://cli.github.com/manual/)             |
| lazygit   | git 的終端機介面                                                       | 看下面的「lazygit 說明書」                                                | [repo](https://github.com/jesseduffield/lazygit) |
| git-delta | 好讀的 diff。連結 `configs/gitconfig` 之後，`git diff`、`git log -p` 會自動使用 | 在 diff 裡按 `n`／`N` 跳到下一個／上一個檔案                                    | [文件](https://dandavison.github.io/delta/)        |
| lefthook  | git hooks 執行器，只有放了 `lefthook.yml` 的 repo 才會啟用                    | 在那樣的 repo 裡執行 `lefthook install`                                 | [文件](https://lefthook.dev/)                      |




### lazygit 說明書

在 repo 裡執行 `lazygit`，按 `q` 離開。**忘了按鍵就按** `?`，會列出目前面板的完整清單（以它為準，下面的按鍵來自官方文件）。設定檔在 `~/Library/Application Support/lazygit/config.yml`（目前是空的，全部用預設值）。

**練習用的 repo**：`./scripts/lazygit-sandbox.sh` 會在 `~/lazygit-sandbox` 建一個練習 repo（分叉的分支、零碎的 wip commit、可以 cherry-pick 的 hotfix、一定會衝突的 rebase），然後 `cd ~/lazygit-sandbox && lazygit`。每次執行都會重建，玩壞了重跑就好，不要在真的 repo 練。

#### 畫面

數字鍵跳面板：`1` 狀態、`2` 檔案、`3` 分支、`4` Commits、`5` Stash。`↑／↓` 選項目，`←／→` 換面板。全域：`P` push、`p` pull、`z` 復原上一步、`Z` 重做。

#### 日常：改檔、commit、push（面板 2）

`space` 暫存／取消暫存、`a` 全部暫存、`c` commit、`A` 合併進上一個 commit（amend）、`d` 捨棄修改（危險）、`s` 存進 stash、`e` 用編輯器開。想只暫存檔案的一部分：選中檔案按 `Enter` 進去，`space` 暫存單行、`a` 選整個區塊。

#### 看分支關係（graph，像 VS Code 的 Git Graph）

- Commits 面板（`4`）**預設就顯示 graph**（官方設定 `git.log.showGraph` 預設是 `always`）。
- **Status 面板（**`1`**）按** `a`：在「目前分支」和「所有分支的 graph」之間切換。想一直顯示所有分支，在 `config.yml` 寫：
  ```yaml
  git:
    log:
      showGraph: always
  gui:
    statusPanelView: allBranchesLog
  ```
- 這是文字畫的 graph（彩色線條），不能點。沒有 lazygit 時：`git log --graph --oneline --all --decorate`。



#### 建分支（面板 3、4）

- 分支面板 `n`：從目前位置建新分支。
- Commits 面板選一個 commit 按 `n`：從那個 commit 開新分支。
- 分支面板：`space` 切換、`M` 合併進目前分支、`f` fast-forward、`d` 刪除。



#### 整理 commit：squash、fixup、改順序（面板 4）

`s` squash（合併進下面那個 commit）、`f` fixup（合併並丟掉訊息）、`r` 改訊息、`Ctrl+j`／`Ctrl+k` 把 commit 往下／往上移、`S` 一次合併所有 `fixup!` commit。互動式 rebase 就是直接對 commit 按這些鍵，不用寫 todo 清單。

#### cherry-pick（面板 4）

在來源分支選 commit 按 `C`（複製），切到目標分支再按 `V`（貼上）。複製錯了按 `Ctrl+r` 清掉選擇。

#### rebase 與解衝突

1. 分支面板選要 rebase 到的分支，按 `r`（把目前分支 rebase 到選中的分支）。選單的選項文字請看畫面，我沒驗證。
2. 有衝突時，到檔案面板（`2`），選衝突的檔案按 `Enter` 進入衝突畫面。
3. 衝突畫面：`↑／↓` 選區塊、`←／→` 在衝突之間移動、`space` 採用選中的那一邊、`b` 兩邊都留、`z` 復原、`e` 用編輯器手動改、`Esc` 回檔案面板。
4. 解完在檔案面板 `space` 暫存，再按 `m`（merge／rebase 選項）選 continue；想放棄選 abort，會回到 rebase 之前的狀態。



#### 救命

`z` 復原、`Z` 重做（靠 reflog，大部分操作都救得回來）、`?` 看按鍵。

#### 官方文件

- [專案首頁（含功能動畫）](https://github.com/jesseduffield/lazygit)
- [完整按鍵清單](https://github.com/jesseduffield/lazygit/blob/master/docs/keybindings/Keybindings_en.md)
- [設定檔所有選項](https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md)
- [Undoing（復原）](https://github.com/jesseduffield/lazygit/blob/master/docs/Undoing.md)
- [Fixup commits](https://github.com/jesseduffield/lazygit/blob/master/docs/Fixup_Commits.md)
- [Range select（一次選多個）](https://github.com/jesseduffield/lazygit/blob/master/docs/Range_Select.md)
- [Stacked branches](https://github.com/jesseduffield/lazygit/blob/master/docs/Stacked_Branches.md)
- [搜尋](https://github.com/jesseduffield/lazygit/blob/master/docs/Searching.md)
- [所有文件目錄](https://github.com/jesseduffield/lazygit/tree/master/docs)



## 舊指令的現代替代品


| 工具      | 取代           | 先試試看                                               | 文件                                                               |
| ------- | ------------ | -------------------------------------------------- | ---------------------------------------------------------------- |
| eza     | `ls`、`tree`  | `eza -l --git`、`eza --tree --level=2 --git-ignore` | [repo](https://github.com/eza-community/eza)                     |
| bat     | `cat`        | `bat file.ts`、`bat -p file`（不顯示行號）                 | [repo](https://github.com/sharkdp/bat)                           |
| ripgrep | `grep -r`    | `rg "文字"`、`rg -t ts "文字"`、`rg -l "文字"`（只列檔名）       | [指南](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md) |
| fd      | `find`       | `fd 名稱`、`fd -e ts`（依副檔名）                           | [repo](https://github.com/sharkdp/fd)                            |
| jq      | 手動讀 JSON     | `jq . file.json`、`jq '.a.b' file.json`             | [手冊](https://jqlang.org/manual/)                                 |
| btop    | `top`、`htop` | `btop`，按 `q` 離開                                    | [repo](https://github.com/aristocratos/btop)                     |
| duf     | `df`         | `duf`                                              | [repo](https://github.com/muesli/duf)                            |
| dust    | `du`         | `dust -d 2`（只看兩層）                                  | [repo](https://github.com/bootandy/dust)                         |
| tlrc    | 簡短的 `man`    | `tldr tar`                                         | [repo](https://github.com/tldr-pages/tlrc)                       |
| tree    |              | `tree -L 2`（保留它，因為 agent 和文件會直接呼叫）                 |                                                                  |


`eza`、`bat` 刻意不用 alias 蓋掉 `ls`、`cat`：alias 可能改變 Claude Code 解析的輸出格式。請自己打新名字。

## 執行環境：mise

Node、pnpm、bun 的版本寫在 `configs/mise.toml`（連結到 `~/.config/mise/config.toml`）。

- `mise ls` 看目前生效的版本，`mise doctor` 做健康檢查。
- 進入有 `mise.toml`、`.tool-versions`、`.nvmrc` 或 `.node-version` 的 repo，Node 會自動切換。`.nvmrc` 能用是因為 `configs/mise.toml` 為 node 打開了這個功能（已用實際程式驗證）。
- 版本還沒裝時，第一次執行該工具（`mise x`，或找不到指令時）才會安裝；單純 `cd` 不會裝。`mise install` 會一次裝完所有宣告的版本。
- 只為某個 repo 固定版本：`mise use node@22`（會寫出 `mise.toml`）。文件：[mise.jdx.dev](https://mise.jdx.dev/)。
- 刻意不全域安裝 yarn：專案需要時再在那個專案裡加。



## 網路與機密


| 工具                  | 是什麼                        | 先試試看                                                                 | 文件                                                                                   |
| ------------------- | -------------------------- | -------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| cloudflared         | 把 localhost 變成暫時的公開網址，不用帳號 | `cloudflared tunnel --url http://localhost:3000`                     | [文件](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/) |
| mkcert              | 本機信任的 HTTPS 憑證             | `mkcert -install`，然後 `mkcert localhost`                              | [repo](https://github.com/FiloSottile/mkcert)                                        |
| Bitwarden CLI（`bw`） | 在終端機讀 Bitwarden 裡的機密       | `bw login`、`bw unlock`、`bw list items --search 名稱`（怎麼拿來管 token：還沒決定） | [文件](https://bitwarden.com/help/cli/)                                                |
| mas                 | 用命令列裝 Mac App Store 的 app  | `mas list`、`mas install <id>`（要先登入 App Store）                        | [repo](https://github.com/mas-cli/mas)                                               |


用手機看開發中的網站：手機和 Mac 連同一個 Wi-Fi，開 `http://<Mac 的 IP>:3000`（Next.js 啟動時會印出 Network 網址）。不同網路或需要 HTTPS 時，用 cloudflared。

## App


| App                          | 是什麼                                 | 備註                                                                                                                              | 文件                                                     |
| ---------------------------- | ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| Raycast                      | 啟動器、視窗管理、剪貼簿歷史                      | 預設 `Option+Space`；這個 repo 把 Spotlight 的 `Cmd+Space` 關掉，改給 Raycast                                                               | [手冊](https://manual.raycast.com/)                      |
| Cursor／VS Code               | 編輯器                                 | Cursor 有 AI 功能                                                                                                                  | [cursor.com](https://cursor.com/docs)                  |
| Claude                       | 聊天與 Code 分頁的桌面 app                  | Claude Code 本體由 `scripts/install-claude-code.sh` 安裝                                                                             | [文件](https://code.claude.com/docs)                     |
| OrbStack                     | Docker 與 Linux 虛擬機                  | 安裝後 `docker` 指令就能用；想要介面用 `lazydocker`                                                                                           | [文件](https://docs.orbstack.dev/)                       |
| Bitwarden                    | 密碼管理器 app                           |                                                                                                                                 | [說明](https://bitwarden.com/help/)                      |
| Bruno                        | API 用戶端，collection 是 repo 裡的純文字檔    | 開一個資料夾當 collection，再 commit                                                                                                     | [文件](https://docs.usebruno.com/)                       |
| Beekeeper Studio             | 資料庫圖形介面（Postgres、MySQL、SQLite）      |                                                                                                                                 | [文件](https://docs.beekeeperstudio.io/)                 |
| Obsidian                     | Markdown 筆記                         | vault 其實就是一個資料夾                                                                                                                 | [說明](https://help.obsidian.md/)                        |
| Shottr                       | 截圖，含標註與 OCR 文字辨識；免費版 30 天後會提示付費     | 不能錄影，錄影用 macOS 內建的 `Cmd+Shift+5`；考慮買 CleanShot X（見 `Brewfile.optional`）                                                         | [shottr.cc](https://shottr.cc/)                        |
| Stats                        | 在選單列顯示 CPU、記憶體、網路                   | 點圖示看詳細                                                                                                                          | [repo](https://github.com/exelban/stats)               |
| AltTab                       | 有縮圖的視窗切換器                           | 預設 `Option+Tab`                                                                                                                 | [alt-tab.app](https://alt-tab.app/)                    |
| DevUtils                     | 離線工具箱：JSON、Base64、JWT、雜湊、時間戳        |                                                                                                                                 | [devutils.com](https://devutils.com/)                  |
| Karabiner-Elements           | 鍵盤重新對應；設定在 `configs/karabiner.json` | 只接管外接鍵盤（`hfd.cn`），內建鍵盤設為 `ignore`。Karabiner 只有一個虛擬鍵盤，版面是 ANSI；公司筆電的內建鍵盤是日文（JIS），如果被接管，`¥`、`_`、`:`、`@` 等鍵會錯位。換到有不同內建鍵盤的電腦，記得檢查這點 | [文件](https://karabiner-elements.pqrs.org/docs/)        |
| Scroll Reverser              | 滑鼠與觸控板分別設定捲動方向                      |                                                                                                                                 | [pilotmoon.com](https://pilotmoon.com/scrollreverser/) |
| Coffee（Raycast 擴充功能）         | 防止 Mac 休眠，取代了 Caffeine              | 在 Raycast 打 `coffee`                                                                                                            |                                                        |
| Notion、Notion Calendar、Figma | 工作工具                                |                                                                                                                                 |                                                        |
| Slack、Linear                 | 公司 profile                          |                                                                                                                                 |                                                        |
| Discord、NordVPN、IINA         | 個人 profile                          |                                                                                                                                 |                                                        |




## 快捷鍵速查

每天用的先背這 7 個，其他用到再查。視窗管理的快捷鍵要在 Raycast 裡手動設（指令名稱 → `Cmd+K` → Configure Command），無法寫進腳本。


| 快捷鍵                | 用途              | 什麼時候用                 |
| ------------------ | --------------- | --------------------- |
| `Cmd+Space`        | 叫出 Raycast      | 開 app、找檔案、執行所有指令的入口   |
| `Shift+Cmd+V`      | 剪貼簿歷史           | 找剛才複製過的東西，直接貼上        |
| `Option+Tab`       | AltTab 切換視窗     | 同一個 app 開了多個視窗時，用縮圖分辨 |
| `Ctrl+Opt+←` / `→` | 視窗左半、右半         | 兩個視窗並排                |
| `Ctrl+Opt+Return`  | 視窗最大化           | 不進全螢幕的放大              |
| `Cmd+Shift+.`      | Finder 顯示或隱藏隱藏檔 | 要看 `.git`、`.zshrc` 時  |
| `Cmd+Shift+G`      | Finder 跳到路徑     | 貼上路徑直接到               |


用到再查：


| 快捷鍵                       | 用途                                        |
| ------------------------- | ----------------------------------------- |
| `Ctrl+Opt+↑` / `↓`        | 視窗上半、下半                                   |
| `Ctrl+Opt+C`              | 視窗置中                                      |
| `Ctrl+Opt+U` `I` `J` `K`  | 視窗的四個角落（大螢幕才有用）                           |
| `Ctrl+Opt+N`              | 視窗移到下一個螢幕（有外接螢幕才有用）                       |
| `Cmd+Shift+A` / `H` / `D` | Finder 到應用程式、家目錄、桌面                       |
| `Cmd+Option+L`            | Finder 到下載項目                              |
| `Fn+Q`                    | 快速備忘錄（見 [APPLE_NOTES.md](APPLE_NOTES.md)） |
| `Cmd+Option+F`            | 在備忘錄搜尋全部                                  |


外接鍵盤 K500E-B94 由 Karabiner 對調左 Cmd 與左 Option，上表的 `Cmd`、`Option` 指對調後的結果。

## IINA 快捷鍵

設定在 `configs/iina-input.conf`，由 `link-terminal-config.sh` 連結成 IINA 的 `mine.conf`。內容是 IINA 預設快捷鍵再加上畫面縮放與移動。新電腦要在 IINA 的 Settings → Key Bindings 把設定檔選成 `mine`（這個選擇存在 IINA 自己的偏好設定裡）。改設定後要把 IINA 完全關掉再開，它不會重讀檔案。

| 快捷鍵 | 用途 |
| --- | --- |
| `Ctrl+=` / `Ctrl+-` | 放大／縮小畫面內容 |
| `Ctrl+Shift+方向鍵` | 放大後往那個方向看 |
| `Ctrl+0` | 縮放和位置一起還原 |
| `Cmd+]` / `Cmd+[` | 播放速度 ×2／×0.5（`Opt+Cmd` 加括號是每次 ×1.1） |
| `Cmd+\` | 速度回到正常 |
| `Cmd+0`／`1`／`2`／`3` | 視窗 0.5 倍／原始／2 倍／符合螢幕 |
| `Cmd+L` | A-B 區間重複 |

外接鍵盤的 Cmd 與 Option 被 Karabiner 對調，上表以對調後為準。完整預設值看 `/Applications/IINA.app/Contents/Resources/config/iina-default-input.conf`。

## Raycast 設定清單

Raycast 的快捷鍵、別名、擴充功能的開關存在它自己的加密資料庫，無法寫進腳本，也不進 repo。換機器時用 Settings → Advanced 的 Export／Import（匯出檔有密碼，不要放進 repo 或聊天，匯入後刪掉），或照這份清單重設。原則：只留「會搜尋名字叫出來」的指令，選單列項目和 AI、Pro 功能一律關。

### 快捷鍵與 Favorites


| 項目                | 設定                                                                                   |
| ----------------- | ------------------------------------------------------------------------------------ |
| Raycast           | `Cmd+Space`（Spotlight 的快捷鍵由 `macos-defaults.sh` 保持關閉）                                |
| Clipboard History | `Shift+Cmd+V`；主要動作貼上；偏好純文字；不記錄 Keychain Access、Passwords、Bitwarden、Ghostty           |
| 視窗管理              | `Ctrl+Opt` 加方向鍵（半邊）、`Return` 或 `M`（最大化）；每個指令要打勾啟用                                    |
| Favorites         | 只放 Dock 沒有的指令：List Repos、Coffee、Kill Process、Color Picker、Translate。Dock 上固定的 app 不放 |




### 別名

先設前六個，其餘用過幾天再補。


| 別名                    | 指令                                                                                         |
| --------------------- | ------------------------------------------------------------------------------------------ |
| `repo`                | Git Repos 的 List Repos                                                                     |
| `port`                | Port Manager 的 Open Ports                                                                  |
| `kp`                  | Port Manager 的 Kill Process Listening on                                                   |
| `nn`                  | Apple Notes 的 New Note                                                                     |
| `timer`               | Timers 的 Start Custom Timer                                                                |
| `cf`                  | Coffee 的 Toggle Caffeinate                                                                 |
| `ob`、`od`             | Obsidian 的 Search Note、Daily Note                                                          |
| `tab`                 | Google Chrome 的 Search Tabs                                                                |
| `url`、`jwt`、`ts`、`fj` | DevUtils 的 URL Parser、JWT Debugger、Unix Time Converter，Format JSON 的 Format Clipboard JSON |




### 內建擴充功能：停用

AI、Dictation、Screen Awareness、MCP（Raycast 的 MCP 只給 Raycast AI 用，和 Claude 的 MCP 無關）、Raycast for Teams、Raycast Notes、Raycast Focus、Typing Practice、Contacts、Calendar、Apple Shortcuts、Dictionary。Script Commands 要開，見下方。

### 商店擴充功能


| 擴充功能          | 留的指令                                                                                                              | 備註                                                                                                      |
| ------------- | ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| Git Repos     | List Repos                                                                                                        | Repo Scan Path `~/Documents/projects`，深度 3；Enter 用 Cursor 開，Cmd+Enter 用 Finder。Ghostty 無法在指定資料夾開新視窗，不要設 |
| Port Manager  | Open Ports、Kill Process Listening on                                                                              | Kill Signal 選 SIGTERM；關掉選單列                                                                             |
| Kill Process  | Kill Process                                                                                                      | 開 Show Process Path；不要開「不再確認」                                                                           |
| Color Picker  | Pick Color、Convert Color、Organize Colors                                                                          | 關選單列                                                                                                    |
| GitHub        | Search Repositories、My Pull Requests                                                                              | 用瀏覽器授權登入，不填 Token；Default Clone Path 設 `~/Documents/projects`；關掉選單列                                     |
| Apple Notes   | New Note、Search Notes、Add Text to Note                                                                            | 關 AI 和選單列；規則見 [APPLE_NOTES.md](APPLE_NOTES.md)                                                          |
| Notion        | Search Notion、Manage Notion Connection                                                                            | 收集箱只用 Apple 備忘錄，所以關 Quick Capture 等                                                                     |
| Google Chrome | Search Tabs、Search Bookmarks、New Tab、Search History                                                               |                                                                                                         |
| Timers        | Start Custom Timer、Stop Running Timer、Dismiss Ringing Timer、Manage Timers                                         | 關選單列                                                                                                    |
| Coffee        | 取代 Caffeine                                                                                                       |                                                                                                         |
| DevUtils      | JWT Debugger、URL Parser、Base64、UUID、Unix Time、HTML to JSX、RegExp、Text Diff、Hash、String Case、JSON↔YAML、Auto Detect | 這些指令只是 DevUtils app 的遙控器，不能刪 app；JSON 格式化交給 Format JSON                                                 |
| Format JSON   | Format Clipboard JSON、Format Selected JSON                                                                        |                                                                                                         |
| Mole          | Uninstall App、Analyze Disk、Purge Dev Artifacts                                                                    | 需要命令列的 `mo`；會刪東西的 Clean System 等關掉                                                                      |
| Slack、Linear  | 家裡不用，工作那台再看                                                                                                       | Slack 要 `xoxp-` Token，需公司許可；Token 存 Bitwarden，不貼到聊天                                                     |


Cloud Sync 是 Pro 功能，不買；兩台之間用 Export／Import。

### Script Commands：下載影片

`scripts/raycast/download-video.sh` 讓你複製網址後，在 Raycast 打 `Download Video`，按 Tab 進入網址欄、貼上、Enter，就在背景下載 4K 以內的最佳畫質（存成 mkv，放 `~/Downloads`），完成會跳通知。需要 `yt-dlp` 和 `ffmpeg`（`Brewfile.personal` 有裝）。

設定：Raycast 的 Script Commands 開啟，再 `Add Script Directory` 選 `scripts/raycast`。新版 YouTube 只抓到 360p 時，先 `brew upgrade yt-dlp`。要手動下載或指定格式：`yt-dlp --no-playlist -F "網址"` 看格式，再用 `-f` 指定。

## 這個 repo 的 Claude Code 設定

見 [README](../README.md)：skills（`skill-list`、`skill-add`、`skill-update`）、安全守衛 hook、通知、狀態列。