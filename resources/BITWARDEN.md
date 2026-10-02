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
