# Agent Skills

Community skills via `npx skills` in `.agents/skills/`, custom skills in `skills/`. After adding or creating a skill, run `../scripts/link-agent-config.sh --no-update`.

## Active skills

| Skill                            | Description                                                                   | Upstream                                                                                                                      |
| -------------------------------- | ----------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `/caveman`                       | Ultra-compressed communication — ~75% fewer tokens, same technical accuracy   | [mattpocock/skills](https://github.com/mattpocock/skills/blob/main/skills/productivity/caveman/SKILL.md)                      |
| `/diagnose`                      | Disciplined debug loop: reproduce → minimise → hypothesise → instrument → fix | [mattpocock/skills](https://github.com/mattpocock/skills/blob/main/skills/engineering/diagnose/SKILL.md)                      |
| `/grill-me`                      | Interview relentlessly about a plan until every decision branch is resolved   | [mattpocock/skills](https://github.com/mattpocock/skills/blob/main/skills/productivity/grill-me/SKILL.md)                     |
| `/grill-with-docs`               | Grill session that sharpens terminology and updates CONTEXT.md + ADRs inline  | [mattpocock/skills](https://github.com/mattpocock/skills/blob/main/skills/engineering/grill-with-docs/SKILL.md)               |
| `/handoff`                       | Compact the conversation into a handoff doc for another agent                 | [mattpocock/skills](https://github.com/mattpocock/skills/blob/main/skills/productivity/handoff/SKILL.md)                      |
| `/improve-codebase-architecture` | Find deepening opportunities using CONTEXT.md and docs/adr/                   | [mattpocock/skills](https://github.com/mattpocock/skills/blob/main/skills/engineering/improve-codebase-architecture/SKILL.md) |
| `/prototype`                     | Throwaway prototype — terminal app or UI variations to flesh out a design     | [mattpocock/skills](https://github.com/mattpocock/skills/blob/main/skills/engineering/prototype/SKILL.md)                     |
| `/setup-matt-pocock-skills`      | Scaffold per-repo issue tracker, triage labels, and domain docs (run once)    | [mattpocock/skills](https://github.com/mattpocock/skills/blob/main/skills/engineering/setup-matt-pocock-skills/SKILL.md)      |
| `/tdd`                           | Red-green-refactor test-driven development, one vertical slice at a time      | [mattpocock/skills](https://github.com/mattpocock/skills/blob/main/skills/engineering/tdd/SKILL.md)                           |
| `/teach`                         | Teach a skill or concept over multiple sessions in this workspace             | [mattpocock/skills](https://github.com/mattpocock/skills/blob/main/skills/productivity/teach/SKILL.md)                        |
| `/to-issues`                     | Break a plan or PRD into vertical-slice issues on the issue tracker           | [mattpocock/skills](https://github.com/mattpocock/skills/blob/main/skills/engineering/to-issues/SKILL.md)                     |
| `/to-prd`                        | Turn conversation context into a PRD on the issue tracker                     | [mattpocock/skills](https://github.com/mattpocock/skills/blob/main/skills/engineering/to-prd/SKILL.md)                        |
| `/triage`                        | Triage issues through a state machine of triage roles                         | [mattpocock/skills](https://github.com/mattpocock/skills/blob/main/skills/engineering/triage/SKILL.md)                        |
| `/write-a-skill`                 | Create a new skill with proper structure and progressive disclosure           | [mattpocock/skills](https://github.com/mattpocock/skills/blob/main/skills/productivity/write-a-skill/SKILL.md)                |
| `/zoom-out`                      | Broader context on an unfamiliar section of code                              | [mattpocock/skills](https://github.com/mattpocock/skills/blob/main/skills/engineering/zoom-out/SKILL.md)                      |
| `/pr`                            | Create a well-documented PR via GitHub CLI                                    | (custom)                                                                                                                      |

## Starred repos

- [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)
- [mattpocock/skills](https://github.com/mattpocock/skills)

## References

- [npx skills CLI](https://github.com/vercel-labs/skills)
- [5 Agent Skills I Use Every Day](https://www.aihero.dev/5-agent-skills-i-use-every-day)
