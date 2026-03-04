# template-claude-code-open

> **EN:** Claude Code base template with persistent memory, spec management, specialized skills, isolated agents, path-scoped rules and security hooks — self-contained, no external dependencies.
>
> **PT-BR:** Template base para projetos com Claude Code. Memória persistente, gestão de specs por feature, skills especializadas, agents isolados, regras por caminho e hooks de segurança — independente, sem dependências externas.

---

## The problem this template solves

Every time you open Claude Code in a project, it knows nothing:

- What is the stack?
- What are the team rules?
- What has been tried and didn't work?
- What is being implemented right now?

With this template, Claude answers all of this by itself before you type the first message.

## How it works

```
First time
  → Claude detects empty MEMORY.md → runs /project-init
  → Asks: "English or Português?" — you choose once
  → All questions, responses and generated files in your language
  → Project is fully configured in minutes

Every session after
  → Claude reads MEMORY.md (context, rules and your language)
  → Claude reads specs/INDEX.md (what is in progress)
  → Claude checks lessons.md before any technical decision
  → Path-scoped rules load automatically for the files being edited

You request a feature
  → /planner creates a formal plan before coding
  → /spec-create registers the spec
  → Implements following the project rules
  → Records what was learned for future sessions

Another dev (or another session) picks up the work
  → git pull → updated context + agent memory
  → Continues exactly where it stopped — no briefing needed
```

---

## Quick start

**New project:**
```bash
gh repo create my-project --template [OWNER]/template-claude-code-open --clone
cd my-project && claude
# Claude detects empty MEMORY.md and starts /project-init automatically
```

**Existing project:**
```bash
cd my-existing-project
gh repo clone [OWNER]/template-claude-code-open /tmp/cc-template -- --depth=1 --quiet && bash /tmp/cc-template/adopt.sh; rm -rf /tmp/cc-template
claude
# Run: /project-adopt — Claude maps the codebase before asking anything
```

→ **[Full guide: QUICKSTART.md](QUICKSTART.md)**

---

## Structure

```
template-claude-code-open/
├── CLAUDE.md                         # Navigation map and session protocol
├── QUICKSTART.md                     # 5-minute guide
├── adopt.sh                          # Adds .claude/ structure to existing projects
├── docs/
│   ├── architecture.md
│   ├── customization.md
│   └── team-workflow.md
└── .claude/
    ├── settings.json                 # Hook configuration (shared)
    ├── settings.local.json.example   # Personal hooks template (gitignored when renamed)
    ├── skills/                       # /slash-commands
    │   ├── project-init/SKILL.md     # Onboarding — new blank project
    │   ├── project-adopt/SKILL.md    # Onboarding — existing project
    │   ├── spec-create/SKILL.md      # Creates spec for new feature
    │   ├── bugfix/SKILL.md           # Systematic bug triage
    │   ├── pr-review/SKILL.md        # PR checklist
    │   ├── commit/SKILL.md           # Commit message format
    │   └── deploy/SKILL.md           # Deploy checklist
    ├── agents/
    │   ├── code-reviewer.md          # Reviews code — isolated worktree, read-only
    │   ├── researcher.md             # Explores codebase — isolated worktree, project memory
    │   └── planner.md                # Generates PRDs and plans
    ├── hooks/
    │   ├── block-destructive.sh      # Blocks rm -rf, force push, DROP TABLE, etc.
    │   ├── auto-format.sh            # Auto-formats after edits (async)
    │   └── session-end-context.sh    # Auto-commits memory/specs at session end (opt-in)
    ├── rules/
    │   ├── _example-frontend.md      # Template: rules for React/TS files
    │   └── _example-api.md           # Template: rules for API/backend files
    ├── memory/
    │   ├── MEMORY.md                 # Living project context (read every session)
    │   ├── lessons.md                # What worked and what didn't
    │   ├── decisions.md              # Architectural decisions with the why
    │   └── patterns.md               # Efficient patterns specific to the project
    ├── agent-memory/                 # Shared agent memory — committed to git
    ├── specs/
    │   ├── INDEX.md                  # Control panel — state of all features
    │   └── _template.md              # Template for creating new specs
    └── references.md                 # Official docs to check before web search
```

---

## Skills

| Skill | When to invoke |
|-------|----------------|
| `/project-init` | New project — automatic onboarding |
| `/project-adopt` | Existing project — `"/project-adopt"` |
| `/spec-create` | `/spec-create [feature]` |
| `/bugfix` | `/bugfix [description]` |
| `/pr-review` | Before opening a PR |
| `/commit` | `/commit` |
| `/deploy` | Before any deploy |

## Agents

| Agent | When to invoke |
|-------|----------------|
| `code-reviewer` | `"use the code-reviewer agent on module [X]"` |
| `researcher` | `"use the researcher agent for [question]"` |
| `planner` | `"use the planner agent for [feature]"` |

## Rules (path-scoped)

Files in `.claude/rules/` with `paths:` frontmatter load automatically only when Claude works with matching files — saving context and keeping rules focused.

```
.claude/rules/
├── _example-frontend.md    ← customize for React/TS projects
└── _example-api.md         ← customize for backend/API projects
```

---

## Team sync

Memory, specs and agent-memory are versioned files — no extra infrastructure needed.

```bash
# Start of session
git pull

# End of session
git add .claude/memory/ .claude/specs/ .claude/agent-memory/
git commit -m "chore(context): update memory/specs"
git push

# Or enable auto-commit at session end:
# Copy .claude/settings.local.json.example → .claude/settings.local.json
```

→ **[Full team guide: docs/team-workflow.md](docs/team-workflow.md)**

---

## Documentation

| Document | Content |
|----------|---------|
| [QUICKSTART.md](QUICKSTART.md) | From zero to first code in 5 minutes |
| [docs/architecture.md](docs/architecture.md) | How the system works internally |
| [docs/customization.md](docs/customization.md) | How to adapt skills, agents, rules and hooks |
| [docs/team-workflow.md](docs/team-workflow.md) | Workflow for remote teams |

---

## License

MIT — see [LICENSE](LICENSE)
