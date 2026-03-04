# Skills available

Invoke directly with `/skill-name` or let Claude invoke automatically when relevant (unless `disable-model-invocation: true`).

| Skill | Directory | When to use |
|-------|-----------|-------------|
| `/project-init` | `project-init/` | First session — new blank project |
| `/project-adopt` | `project-adopt/` | Existing project receiving the structure for the first time |
| `/spec-create` | `spec-create/` | Start a new feature or phase |
| `/bugfix` | `bugfix/` | Bug report — systematic triage until verified fix |
| `/pr-review` | `pr-review/` | Before opening or reviewing a PR |
| `/commit` | `commit/` | Format and validate commit message |
| `/deploy` | `deploy/` | Before any deploy |

## Structure

Each skill is a directory with `SKILL.md` as the entrypoint:

```
.claude/skills/<skill-name>/
├── SKILL.md        ← instructions + YAML frontmatter (required)
├── examples/       ← example outputs (optional)
└── scripts/        ← scripts Claude can execute (optional)
```

## Frontmatter fields (in SKILL.md)

| Field | Description |
|-------|-------------|
| `name` | Slash-command name (e.g. `deploy` → `/deploy`) |
| `description` | What the skill does — Claude uses this to decide when to apply it |
| `disable-model-invocation` | `true` = only you can invoke it (Claude won't auto-trigger) |
| `allowed-tools` | Tools Claude can use without asking permission when skill is active |
| `model` | Model override for this skill |
| `context: fork` | Run in an isolated subagent context |
| `argument-hint` | Hint shown during autocomplete (e.g. `[feature-name]`) |

## How to invoke

```
/project-init
/spec-create user-authentication
/bugfix checkout page crashes on mobile
/deploy staging
```

## How to add a new skill

```bash
mkdir -p .claude/skills/my-skill
# Create SKILL.md with frontmatter + instructions
```

Reference: https://code.claude.com/docs/en/skills
