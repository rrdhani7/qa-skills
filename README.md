# qa-skills

Portable QA agent skills. Works with any agent CLI that loads skills from
`.claude/skills/` or `.agents/skills/` (Claude Code, Codex, Gemini CLI, and
friends).

## Skills

| Skill | What it does |
| ----- | ------------ |
| `generate-fe-test-cases` | Generate frontend QA test cases grounded strictly in source material — PRD + Jira + Figma. Scans related PRDs and the existing test-case corpus, decomposes the change into flows, locks scope, applies a coverage floor, and requires a Ground Truth per case. Outputs one `.xlsx` per sprint (one tab per Jira ticket) via a build script that never destroys sibling tabs. |

## Install

Copy the skills into a project's agent skills folder:

```sh
./install.sh /path/to/your/project
```

- Defaults to `<project>/.claude/skills/`.
- `--dir .agents` targets the `.agents` convention instead.
- `--agents` installs into **both** `.claude` and `.agents`.

Re-running replaces the skill folders in place.

## Layout

```
skills/<name>/
  SKILL.md              procedure — the steps and gates
  references/*.md       reference — column contract, coverage floor (loaded on demand)
  scripts/*.py          deterministic mechanics (e.g. the .xlsx writer)
install.sh              copy skills into a target project
```

`SKILL.md` holds procedure; `references/` holds the reference material it points to
(loaded only when a step needs it); `scripts/` holds the deterministic parts that
must not be improvised.

## Notes

`generate-fe-test-cases` currently carries bindings to a specific Obsidian
vault (vault paths, product→subject table, a titis-tcms sync target). To reuse it
elsewhere, adjust those bindings — the method (Ground Truth discipline, corpus and
neighbour scans, coverage floor, consolidation) is project-independent.
