# Bitwarden 整理規則

保險庫（密碼管理器）怎麼分類、怎麼命名、欄位怎麼填。新增項目或整理新帳號時照這份做，兩台電腦、手機都用同一套。

這份只寫規則，**不放任何帳號、信箱、密碼或內部網址**。

## 原則

- **依用途分資料夾，不依類型或地區分。** 類型（登入、信用卡、身分、備註）用 Bitwarden 內建的類型篩選找；地區寫在標題裡。
- **一個項目只放一個資料夾。** 同時像兩類的，依「你最常為了什麼打開它」決定。
- **標題一致，才好搜尋。** 搜尋服務名稱，就能列出該服務的全部帳號。

## 資料夾

| 資料夾 | 放什麼 |
|---|---|
| Core Accounts | 主帳號：Google、Apple、GitHub、Bitwarden。丟了其他服務會連帶受影響 |
| Finance | 銀行、證券、保險、支付、信用卡 |
| Dev | 開發服務與其復原碼（AWS、Vercel、各種 API 服務） |
| env | 兩台電腦共用的個人金鑰，由 `bw-env` 載入。專案專用的金鑰不要放這裡 |
| Work | 公司帳號。換公司時整個資料夾一起處理 |
| Shopping | 購物網站、會員 |
| Social | 社群帳號 |
| Media | 影音、漫畫、遊戲、音樂軟體 |
| Life | 水電瓦斯、電信、交通、政府、醫療、住宅、身分資料 |
| Learning | 考試、課程 |
| Inbox | 新增的、還沒決定放哪的。定期清空 |
| Archive | 暫時不用、但還不能刪的（內建 Archive 是付費功能，所以用資料夾代替） |

## 標題

> `服務名稱`；同一服務有多個帳號時才加 `(區分用的簡稱)`

- 單一帳號：`Wise`、`Amazon JP`。
- 多個帳號：`Google (name@gmail.com)`、`Instagram (username)`。
- 環境用括號：`Admin Panel (prod)`。
- 日文、中文服務可以「英文 + 原文」，兩種語言都搜得到：`TEPCO 東京電力`。
- 標題**不加公司前綴**。公司由 Work 資料夾區分；名稱太通用的（例如 Admin Panel）加專案或產品名稱，不是公司名稱。

## 網址比對

- 預設用 **Base domain**（全域設定，大部分項目不用動）。
- 同主網域下有多個帳號或多個租戶，用 **Host**：AWS、日本郵政、SmartHR、IB 的登入入口。
- 登入頁在另一個主網域時，**多加一個網址**，不要只存首頁。
- 網址不支援 `*` 萬用字元。
- App 專用的帳號可以不填網址。

## 自訂欄位（英文，單字首字母大寫）

| 欄位名稱 | 類型 | 用途 |
|---|---|---|
| `Login Method` | Text | 登入方式：`GitHub`、`Apple`、`Passkey`、`App` |
| `2FA` | Text | 兩階段驗證方式：`Google Authenticator`、`Passkey`、`SMS`。只記方式，不記密鑰 |
| `ID Number` | Hidden | 身分證字號 |
| `User Code` | Hidden | 網銀使用者代碼 |
| `Card PIN` | Hidden | 提款密碼（兩者相同時一個欄位就好） |
| `Transaction Password` | Hidden | 網路交易密碼（與提款密碼不同時才加） |
| `Account Number`、`Branch` | Text | 帳號、分行 |
| `Security Q1` / `Security A1` | Text / Hidden | 問答題。答案用密碼產生器的隨機字串，不填真實答案 |
| `Phone Number` | Text | 綁定的手機號碼 |
| `API Key`、`Token` | Hidden | API 金鑰 |
| `Customer Number` | Text | 水電瓦斯等的客戶編號 |
| `License Key` | Hidden | 軟體授權碼 |
| `Subscription` | Text | 付費訂閱方案 |

## 驗證碼（TOTP）與復原碼

- **主帳號的驗證碼放手機的獨立驗證器**，不放 Bitwarden。密碼和驗證碼放同一處，保險庫一被攻破兩道防線同時失效。免費方案也不會產生驗證碼。
- **復原碼**放在「該服務」的項目備註，不另開項目。
- **Bitwarden 自己的復原碼不能存在 Bitwarden 裡**，要離線保存（紙本放安全的地方）。
- Bitwarden 的主密碼同樣不存進保險庫。

## 特殊情況

- **銀行**：登入密碼用原本的密碼欄，其他放自訂欄位。信用卡用 Card 類型。
- **用 GitHub／Apple 登入的服務**：標題照常，`Login Method` 填 `GitHub`，不需要獨立密碼。
- **Basic Auth**：瀏覽器原生登入視窗，Bitwarden 擴充套件無法自動帶入，只能手動複製。
- **專案專用的 API key**：放該服務的項目（Dev），不放 `env`；`env` 的內容會被載入每個終端機。
- **已經不用的雲端帳號**：先放 Archive，確認沒有計費、關閉帳號後才刪除。

## 個人金鑰：`bw-env`

兩台電腦共用的個人金鑰放 `env` 資料夾：項目名稱 = 環境變數名稱，密碼欄 = 值。

```bash
bw-env
```

它會把 `env` 資料夾載入**目前這個終端機**，只印名稱不印值，關掉視窗就消失，不寫入任何檔案。實作在 [configs/bw-env.zsh](../configs/bw-env.zsh)。想讓 Claude Code 看到，先在同一個終端機跑 `bw-env`，再從那裡啟動它。

## 後續策略

### 舊資料的分流（不用一次整理完）

不逐筆比對 Google 密碼管理員，改用「新的進 Bitwarden，舊的隨用隨補」：

1. Chrome 關閉「提供儲存密碼和 passkey」，之後新密碼只會進 Bitwarden。
2. 平常登入網站時，Bitwarden 沒有、Google 有的，就補進 Bitwarden。
3. 半年後 Google 密碼管理員剩下的，就是你沒在用的，整批刪除。

整理時遇到的舊項目，用同一套規則分流：

| 狀況 | 處理 |
|---|---|
| 還在用，但密碼不對 | 用「忘記密碼」重設，立刻更新 |
| 還在用，不知道是什麼 | 放 Inbox，用到時再決定 |
| 確定不要 | 刪除（先進 Trash，30 天內救得回來） |
| 不確定能不能刪（例如雲端帳號可能還在計費） | 放 Archive，確認後再刪 |

### 手機（iPhone）

1. App Store 安裝 Bitwarden，登入同一個帳號。
2. 在 Bitwarden app 的設定開啟 Face ID 解鎖，並設定自動鎖定時間。
3. iOS 設定的「密碼」→「密碼選項」→「自動填入密碼與通行密鑰」，勾選 Bitwarden。路徑依 iOS 版本略有不同。
4. **不要關掉 iCloud 鑰匙圈**：有些 passkey（例如 Wise）存在那裡，關掉可能無法使用。等這類 passkey 搬走後再處理。

App 專用的帳號沒有網址，登入畫面點鍵盤上的「密碼」→ 選 Bitwarden，手動選項目。

### 瀏覽器

- 安裝擴充套件並固定在工具列。
- 自動填入快捷鍵預設是 `Cmd+Shift+L`。「載入頁面時自動填入」預設關閉，維持關閉比較安全。
- 同一個瀏覽器只留一個密碼管理器，避免兩邊重複彈出。

### 工程師適合放進保險庫的東西

| 東西 | 怎麼放 |
|---|---|
| 各種服務的 API key、token | 專案專用的放該服務項目的 `API Key` 欄位（Dev）；兩台共用的放 `env` |
| 專案的 `.env` 內容 | 存成 Secure note（備份用，換電腦時找得到）。免費方案備註有長度限制，太長要拆開 |
| 資料庫、伺服器的連線資訊 | 一個項目，host、port、使用者放自訂欄位，密碼放密碼欄 |
| 復原碼、備用碼 | 放該服務項目的備註 |
| 軟體授權碼 | `License Key` 欄位 |
| Wi-Fi、路由器、NAS 管理密碼 | Life 資料夾 |
| 暫時要交給同事的機密 | 用 **Bitwarden Send**：設到期時間和存取次數，比貼在聊天室安全 |
| SSH 私鑰 | 見下方，**目前不需要** |

**命令列**也能用：`bw get password "項目名稱"` 取單一密碼，`bw generate` 產生密碼，`bw list items --search 關鍵字` 搜尋。

### SSH 金鑰要不要放

Bitwarden 有 **SSH key** 項目類型，桌面 app 也能當 SSH agent，讓私鑰不放在硬碟上，也可以用它簽署 git commit。

你目前 git 走 HTTPS（`gh` 登入），沒有在用 SSH 金鑰，所以**現在不需要**。之後改用 SSH 或需要簽署 commit，再來設定。

### 付費方案值不值得

付費版（約每年 10 美元，以官網為準）多的功能：

| 功能 | 對你的價值 |
|---|---|
| 密碼健檢報告（外洩、弱密碼、重複） | **高**，整理舊帳號時能直接列出該先換的 |
| 附件 | 中，可存 `.env` 檔、金鑰檔 |
| Emergency access（緊急存取） | 中，萬一你出事，可信任的人能申請存取 |
| 內建 TOTP | 低，主帳號的驗證碼本來就不放這 |
| Archive | 低，用資料夾代替 |

### 定期維護

- 每季看一次 Inbox 和 Archive，該刪就刪。
- 定期匯出加密備份（`.json (Encrypted)`），存在安全的離線位置。
- 優先更換 Core Accounts 和 Finance 的弱密碼或重複密碼。

## 回家待辦（搬家完再做）

照順序做，每一項做完再做下一項。

- [ ] **抄寫 Bitwarden 復原碼**：網頁版 Settings → Security → Two-step login → View recovery code。抄在紙上，放安全的地方，最好再抄一份放另一個地點。不要存在雲端、截圖或聊天軟體。
- [ ] **設定 Bitwarden 自動鎖定**：桌面 app 設定的 Security 頁，Timeout 改成 15 分鐘到 1 小時（或系統鎖定時），並勾選 Touch ID 解鎖。
- [ ] **Chrome 關閉儲存密碼**（每個 profile 各做一次）：自動填入和密碼 → Google 密碼管理員 → 設定，關掉「提供儲存密碼和 passkey」與「自動登入」。舊資料先不要刪。
- [ ] **iPhone 設定**：安裝 Bitwarden、登入、開 Face ID 解鎖，再到 iOS 設定的「密碼」→「密碼選項」→「自動填入密碼與通行密鑰」勾選 Bitwarden。**不要關 iCloud 鑰匙圈**。
- [ ] **匯出一份加密備份**：網頁版 Export，格式選 `.json (Encrypted)`，存在離線的安全位置。
- [ ] 之後隨用隨補舊資料，半年後清掉 Google 密碼管理員剩下的（見「舊資料的分流」）。
