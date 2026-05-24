# Project templates

Copy files from a template into a new project repo. Pick the closest match and adjust.

## Usage

```bash
# From your new project root
cp ~/\_configs/agents/templates/general/AGENTS.md .
cp -r ~/\_configs/agents/templates/nextjs/.cursor .   # if using Next.js template
```

## Templates

| Template | Use for |
|----------|---------|
| [general/](general/) | Any project — minimal shared rules |
| [nextjs/](nextjs/) | Next.js / React / TypeScript |
| [python/](python/) | Python apps and scripts |

Each template includes:

- `AGENTS.md` — project-level rules (team-shareable)
- `.cursor/rules/*.mdc` — optional Cursor-only scoped rules (not shared with Claude)

For Claude Code project config, also add `.claude/settings.json` or symlink rules from `AGENTS.md` as needed.
