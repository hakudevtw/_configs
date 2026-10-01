# Pin community skills with a lock file instead of installing them as plugins

mattpocock/skills recommends `/plugin install mattpocock-skills`, which auto-updates per machine. We install it with `npx skills` and pin it in `agent-skills/skills-lock.json` instead, because a skill's version decides file names in our own repos (v1.3 renamed `CONTEXT.md` to `GLOSSARY.md` and stopped reading the old one), so every machine must be on the same version and upgrade only when we choose to, after reading the diff (`skill-update`).

## Considered Options

- **Plugin, auto-update off:** one command to install and no repo involved, but each machine updates its marketplace clone independently, so two Macs can end up on different versions, and the installed set is not recorded in git.

## Consequences

- We track upstream renames and removals ourselves (upstream changed roughly ten skills in three months).
- Plugin-only features such as bundled hooks are not picked up from this source.
- Revisit if upstream stops publishing `npx skills`-compatible sources.
