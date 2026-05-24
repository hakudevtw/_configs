# AI Agents

Personal agent configuration for Cursor, Claude Code, Codex, and Gemini. Run `install.sh` to symlink these into place.

## Layout

```
agents/
├── AGENTS.md          # Global rules (shared) → ~/.claude/CLAUDE.md
├── mcp.json           # Shared MCP server definitions (reference)
├── skills/            # Custom skills (SKILL.md folders) → all agent skill paths
├── claude/            # Claude Code-only settings
└── templates/         # Copy into new projects
```

## What's shared vs. tool-specific

| Config | Shared? | Location |
|--------|---------|----------|
| Global rules | Yes | `AGENTS.md` |
| Skills | Yes | `skills/*/SKILL.md` |
| MCP definitions | Partially | `mcp.json` — sync manually per tool |
| Claude permissions/hooks | No | `claude/settings.json` → `~/.claude/settings.json` |
| Cursor scoped rules | No | `templates/*/.cursor/rules/` — per project only |
| OAuth, session state | No | Stays in each tool (`~/.claude.json`, Cursor settings) |

## Skills

Add a folder under `skills/` with a `SKILL.md` file:

```
skills/my-skill/SKILL.md
```

Install external skills with [skills.sh](https://skills.sh/) or copy from catalogs below, then place them in `skills/`.

### Guides & catalogs

- [Gemini CLI skills](https://geminicli.com/docs/cli/skills/)
- [Vercel Skills](https://github.com/vercel-labs/skills)
- [skills.sh](https://skills.sh/)
- [awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills)
- [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills)

## MCP

`mcp.json` is a shared reference. Each tool stores MCP config differently:

- **Claude Code** — `~/.claude.json` or project `.mcp.json`
- **Cursor** — Settings → MCP
- **Codex** — `~/.codex/config.toml`
- **Gemini** — Gemini CLI settings

Copy server definitions from `mcp.json` when setting up a new tool.

## Project templates

See [templates/README.md](templates/README.md). Copy the folder that matches your project type into a new repo.

## Documentation

- [Cursor rules](https://cursor.com/docs/rules)
- [Claude Code settings](https://code.claude.com/docs/en/settings)
- [Claude Code skills](https://code.claude.com/docs/en/skills)
- [Gemini CLI](https://geminicli.com/docs/)
- [Codex CLI skills](https://openai-codex.mintlify.app/features/skills)
- [Agent Skills standard](https://agents.md/)
