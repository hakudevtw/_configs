# Agent Skills

- `.agents/skills/`：社群 skills，由 `npx skills` 安裝（版本鎖在 `skills-lock.json`）
- `skills/`：自己寫的 skills
- `AGENTS.md`：全域規則，連結到 `~/.claude/CLAUDE.md`
- `mcp.json`：共用的 MCP server，由 `../scripts/sync-mcp-config.sh` 合併進 Claude
- `settings.json`、`hooks/`：Claude Code 的設定、危險指令守衛、狀態列

這裡沒有手寫的 skills 清單，因為手寫的一定會過期。要看目前的清單，請執行 `skill-list`（或 `../scripts/list-skills.sh`），它也會檢查 lock／磁碟／連結是否一致。新增、更新與檢查的流程見 [管理 skills](../README.md#管理-skills)。

## 參考

- [npx skills CLI](https://github.com/vercel-labs/skills)
- [skills.sh](https://skills.sh/)：社群 skills 目錄
- 收藏：[addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)、[mattpocock/skills](https://github.com/mattpocock/skills)
