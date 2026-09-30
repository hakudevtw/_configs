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
│   ├── mcp.json            # Global MCP servers (synced via link-agent-config.sh)
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
| `scripts/link-agent-config.sh` | Claude Code: global rules, MCP, skills (community + custom) |
| `scripts/skill-add.sh` · `skill-update.sh` · `list-skills.sh` | Manage community skills (aliases `skill-add`, `skill-update`, `skill-list`) |

### Config layers

| Layer | What | Where | How it gets to projects |
|-------|------|-------|-------------------------|
| Global personal | Always-on preferences | `agent-skills/AGENTS.md` | Symlinked via `link-agent-config.sh` |
| Project-specific | Domain docs, MCP, scoped rules | Inside each repo | Owned by the project |

## Secrets and per-machine config

Everything in this repo is the **base config** shared by every Mac. Tokens and anything that differs per machine (work vs personal) live in a **machine overlay** outside the repo:

```bash
mkdir -p ~/.config/_configs
cp configs/local.zsh.example ~/.config/_configs/local.zsh
chmod 600 ~/.config/_configs/local.zsh
$EDITOR ~/.config/_configs/local.zsh   # add: export MY_SERVICE_TOKEN="..."
```

- `~/.zshrc` sources `local.zsh` last, so every new shell has the variables.
- Configs reference secrets by name only (e.g. `${MY_SERVICE_TOKEN}` in MCP config), never by value.
- Name variables yourself. Claude Code blanks well-known names (`ANTHROPIC_API_KEY`, `NPM_TOKEN`, …) when used in remote MCP `url`/`headers`.
- **Apps launched from the Dock/Spotlight don't load `~/.zshrc`**, so they won't see these variables. Start Claude Code (or Claude Desktop) from a terminal, or the token expands empty.
- `local.zsh` is plain text (chmod 600). It is gitignored (and will be added to Claude's `permissions.deny` in `settings.json`).

## Agent configuration reference

This repo targets Claude Code (and Claude Desktop for MCP) only.

| Config | Claude location | In this repo |
|--------|-----------------|--------------|
| Global rules | `~/.claude/CLAUDE.md` | `agent-skills/AGENTS.md` (symlink) |
| Skills | `~/.claude/skills/` | `agent-skills/.agents/skills/` (community) + `agent-skills/skills/` (custom) |
| MCP | `~/.claude.json`, Claude Desktop config | `agent-skills/mcp.json` merged in by `sync-mcp-config.sh`; per-machine servers in `~/.config/_configs/mcp.local.json` |
| Project rules | `CLAUDE.md` in each project | Per project |
| Settings | `~/.claude/settings.json` | `agent-skills/settings.json` (symlink) |
| Hooks | `~/.claude/hooks/` | `agent-skills/hooks/` (symlink) |
| OAuth / session | `~/.claude.json` | Stays on each machine |

### Safety guard

`settings.json` denies Claude reading `.env*`, `~/.ssh`, `~/.aws`, `~/.npmrc` and `local.zsh`, and runs `hooks/guard-bash.py` before every Bash call:

- **deny**: recursive `rm` of `/`, `~`, `$HOME`; force push to `main`/`master`
- **ask**: `git reset --hard`, `git clean -f`, force push to other branches

It looks at the command text (through `sudo`, `bash -c`, `$(...)`), so it is a guard against mistakes, not a security boundary: a script that does the deletion itself is not caught. If the hook itself errors it falls back to *ask*.

### Managing skills

Community skills come from GitHub via `npx skills` and are pinned in `agent-skills/skills-lock.json`. Custom skills are hand-written in `agent-skills/skills/<name>/SKILL.md`. Custom wins on name collisions.

```bash
skill-add owner/repo --skill name   # from any directory: install into the repo, then re-link
skill-add owner/repo --list         # browse a repo without installing
skill-update                        # update all community skills, show what changed, re-link
skill-list                          # inventory + check lock / repo / ~/.claude/skills agree
```

Nothing is committed for you. Skills are instructions Claude follows, so read the diff after `skill-update` (`git diff -- agent-skills/.agents`), then commit or `git restore` it. Custom skill: create the `SKILL.md`, then run `scripts/link-agent-config.sh`.

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
