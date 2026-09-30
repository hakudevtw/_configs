# Agent Skills

- `.agents/skills/` — community skills, installed by `npx skills` (pinned in `skills-lock.json`)
- `skills/` — custom skills, hand-written
- `AGENTS.md` — global rules, linked to `~/.claude/CLAUDE.md`
- `mcp.json` — base MCP servers, merged into Claude by `../scripts/sync-mcp-config.sh`

There is no hand-maintained skill list here; it always went stale. Run `skill-list` (or `../scripts/list-skills.sh`) for the current inventory, which also flags lock/disk/link mismatches. Add, update and review workflow: see [Managing skills](../README.md#managing-skills).

## References

- [npx skills CLI](https://github.com/vercel-labs/skills)
- [skills.sh](https://skills.sh/) — community skill directory
- Starred: [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills), [mattpocock/skills](https://github.com/mattpocock/skills)
