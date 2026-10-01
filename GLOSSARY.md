# Machine Config

A personal dotfiles and Claude Code setup kept in one repo and reproduced on several Macs (work and personal).

## Language

**Base config**:
The configuration shared identically by every machine, committed to the repo.
_Avoid_: Shared config, common config

**Machine overlay**:
Per-machine settings and secrets kept outside the repo and never committed; the repo carries only `*.example` templates of it.
_Avoid_: Local config, private config, per-machine branch

**Community skill**:
A skill fetched from an upstream GitHub repo via `npx skills` and pinned in the lock file.
_Avoid_: External skill, installed skill

**Custom skill**:
A skill hand-authored in this repo.
_Avoid_: Personal skill, own skill

**Skill manifest**:
The lock file that records which Community skills, from which upstream, are wanted on every machine.
_Avoid_: Skill list, skill registry

**Secret**:
A token or credential a config needs at runtime; lives only in the Machine overlay and is referenced by variable name from the Base config.
_Avoid_: Key, password, env var (as a synonym)

**Profile**:
The role a machine declares, `work` or `personal`, written in its Machine overlay; it selects which Brewfile layer is installed.
_Avoid_: Environment, mode

**Optional list**:
The Brewfile of things to try or to install only when a situation calls for them; never installed automatically.
_Avoid_: Extras, nice-to-have
