# Haku's MacBook Configuration

Personal dotfiles and AI agent configuration for a new Mac setup.

## Quick start

```bash
git clone <repo-url> ~/_configs
cd ~/_configs
./install.sh
```

`install.sh` is a thin orchestrator — it runs each script in `scripts/` in order. Run individual scripts when you only need to refresh one area.

## Repo layout

```
_configs/
├── install.sh              # Runs all link/sync scripts
├── scripts/                # Single-purpose automation
├── configs/                # Shell and terminal configs
├── agent-skills/           # [Agent Skills](agent-skills/README.md)
│   ├── AGENTS.md           # Global rules → ~/.claude/CLAUDE.md
│   ├── mcp.json            # MCP reference (copy into projects manually)
│   ├── .agents/skills/     # Community skills (npx skills + skills-lock.json)
│   ├── skills/             # Custom global skills (hand-authored)
│   └── skills-lock.json    # Pinned community skill versions
└── resources/              # Setup checklists (apps, terminal, fonts, …)
```

## Scripts

One script per feature area — not per app or service.

| Script | Feature |
|--------|---------|
| `install.sh` | Run all scripts below |
| `scripts/link-terminal-config.sh` | Shell (zsh, spaceship) + terminal (Ghostty) |
| `scripts/link-agent-config.sh` | Global rules and skills (community + custom) |

### Config layers

| Layer | What | Where | How it gets to projects |
|-------|------|-------|-------------------------|
| Global personal | Always-on preferences | `agent-skills/AGENTS.md` | Symlinked via `link-agent-config.sh` |
| Project-specific | Domain docs, MCP, scoped rules | Inside each repo | Owned by the project |

## Agent configuration reference

What's shared vs tool-specific:

| Config | Shared? | Cursor | Claude Code | In this repo |
|--------|---------|--------|-------------|--------------|
| Global rules | Yes | User rules / `AGENTS.md` | `~/.claude/CLAUDE.md` | `agent-skills/AGENTS.md` |
| Skills | Yes | `~/.agents/skills/` | `~/.claude/skills/` | `.agents/skills/` + `skills/` |
| Skills (Antigravity CLI) | Yes | — | `~/.gemini/antigravity-cli/skills/` | same sources, linked by `link-agent-config.sh` |
| Skills (Antigravity app) | Yes | — | `~/.gemini/config/skills/` | same sources, linked by `link-agent-config.sh` |
| MCP | Partially | Settings → MCP | `~/.claude.json` / `.mcp.json` | `agent-skills/mcp.json` (reference) |
| Project rules | No | `.cursor/rules/*.mdc` | `CLAUDE.md` | Per project |
| Settings / hooks / plugins | No | Tool UI | Tool config dirs | Add under `agent-skills/` when needed |
| OAuth / session | No | Cursor settings | `~/.claude.json` | Stays in each tool |

### Skill sync workflow

Community and custom skills live in separate repo dirs but are linked together in one pass:

```bash
cd agent-skills && npx skills add owner/repo --skill name   # writes to .agents/skills/
# or create agent-skills/skills/my-skill/SKILL.md             # custom skill

./scripts/link-agent-config.sh --no-update                    # re-link after add/create
./scripts/link-agent-config.sh                                # same + npx skills update
```

Re-run the link script after installing or creating a skill — it scans both dirs and symlinks each skill into `~/.agents/skills/` and `~/.claude/skills/`. Custom wins on name collisions.

## Resources

- [Agent Skills](agent-skills/README.md) — skill sets, tracking, and references
- [Applications](resources/APPLICATIONS.md) — GUI apps for a new machine
- [Terminal](resources/TERMINAL.md) — Shell, CLI tools, and runtimes
- [System Settings](resources/SYSTEM_SETTINGS.md) — macOS settings checklist
- [Fonts](resources/FONTS.md)

## External docs

- [skills.sh](https://skills.sh/) — community skill directory
- [npx skills CLI](https://github.com/vercel-labs/skills)
- [Cursor skills](https://cursor.com/docs/skills) · [rules](https://cursor.com/docs/rules) · [plugins](https://cursor.com/docs/plugins)
- [Claude Code settings](https://code.claude.com/docs/en/settings) · [skills](https://code.claude.com/docs/en/skills) · [plugins](https://code.claude.com/docs/en/plugins)
- [Agent Skills standard](https://agents.md/)
