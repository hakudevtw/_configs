# 交接：把 _configs 搬到 ~/Documents/_me/_configs（2026-10-18）

家裡的電腦已經搬完。這份給**公司電腦**照做，把 `~/_configs` 搬到新位置並重新連結。約 5 分鐘。

## 為什麼搬
`~/Documents/_me/` 是個人管理資料夾：`_configs`（設定）、`_second-brain-obsidian`（第二大腦 vault）、`hq-blueprint`（公司構想）。打開一個資料夾就能跨 repo 工作。公司電腦只需要 `_configs`，另外兩個沒有就不用管。

## 先確認
- 系統設定 → Apple 帳號 → iCloud → iCloud 雲碟 → 「桌面與文件檔案夾」**關閉**。開著的話 git repo 放進 Documents 會被 iCloud 同步干擾，先不要搬。
- 關掉 Claude Code、Cursor、Zed 等正在用這些設定的 app（終端機留一個 Ghostty 視窗就好）。

## 步驟
```bash
mkdir -p ~/Documents/_me
mv ~/_configs ~/Documents/_me/_configs
cd ~/Documents/_me/_configs
git pull
./scripts/link-terminal-config.sh
./scripts/link-agent-config.sh
```

腳本沒管到的零散連結（例如 `~/.agents/skills`、`~/.gemini/.../skills`），用這段把還指向舊路徑、而新位置存在的連結改過去；新位置不存在的只列出來不動：
```bash
find ~ -maxdepth 5 -type l -lname "$HOME/_configs*" 2>/dev/null | while read -r l; do
  t=$(readlink "$l"); n="$HOME/Documents/_me/_configs${t#$HOME/_configs}"
  if [ -e "$n" ]; then ln -sfn "$n" "$l"; else echo "已經壞掉（搬之前就不存在）：$l -> $t"; fi
done
```

## 驗證
- 開一個**新的** Ghostty 分頁：提示符正常、`node -v` 有版本、`git config user.name` 有值。
- `ls -la ~/.claude/settings.json ~/.claude/CLAUDE.md ~/.claude/hooks` 都指向 `~/Documents/_me/_configs/...`。
- `find ~ -maxdepth 5 -type l -lname "$HOME/_configs*"` 只剩上一步列出的「已經壞掉」連結。

## 可選
- Claude Code 曾在 `~/_configs` 開過專案的話，`~/.claude.json` 的 `projects` 裡有舊路徑的設定；新路徑第一次開時會重新詢問信任，照常允許即可。
- 上面列出的「已經壞掉」連結是之前從 repo 移除的 skill 或設定留下的，可以手動刪除。
