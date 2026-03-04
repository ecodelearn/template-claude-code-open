# Quickstart

> New project? Follow **Steps 1–5** / Projeto novo? Siga os **Passos 1–5**.
> Existing project? Jump to **[Existing project](#existing-project)**

---

## Prerequisites

- [Claude Code](https://github.com/anthropics/claude-code) installed (`npm install -g @anthropic-ai/claude-code`)
- [GitHub CLI](https://cli.github.com/) authenticated (`gh auth login`)
- Git configured

---

## Step 1 — Create the project from the template

```bash
gh repo create my-project --template [OWNER]/template-claude-code-open --clone
cd my-project
```

> Manual clone:
> ```bash
> git clone https://github.com/[OWNER]/template-claude-code-open.git my-project
> cd my-project
> rm -rf .git && git init
> gh repo create my-project --source=. --push
> ```

---

## Step 2 — Open Claude Code

```bash
claude
```

---

## Step 3 — Automatic onboarding (/project-init)

Claude detects that `MEMORY.md` is empty and starts `/project-init` automatically.

First, Claude asks for your **language preference** (asked once, in both languages):

```
What language do you prefer to work in?
Qual idioma você prefere para trabalhar?

1 — English
2 — Português
```

From that point on, everything — questions, responses, generated files — will be in the chosen language.

Then you answer **7 conversational questions** — one at a time:

| # | Question | Example |
|---|----------|---------|
| 0 | Language preference | `1` (English) or `2` (Português) |
| 1 | Project slug and name | `my-api` / "B2B order REST API" |
| 2 | Tech stack | Node.js + Fastify + PostgreSQL + Redis |
| 3 | Non-negotiable rules | "Always PNPM, never alter migrations" |
| 4 | Team size | "Team of 3" |
| 5 | MCP integrations | GitHub, PostgreSQL |
| 6 | Library documentation | Fastify, Prisma, Vitest |
| 7 | Initial state | "Starting from scratch" |

**What is configured automatically:**
- `MEMORY.md` filled with project context
- `CLAUDE.md` updated with the real name and rules
- `references.md` populated with official lib links
- `README_MCP.md` created with integration setup instructions (if integrations were specified)

---

## Step 4 — Create the first spec

```
/spec-create user-authentication
```

Claude creates `.claude/specs/feature-auth.md` and updates `specs/INDEX.md`.

---

## Step 5 — Start implementing

```
implement the feature-auth spec
```

Claude reads the spec, checks memory and lessons, and delivers code following the project rules.

> **Definition of Done:** a spec is only marked as `done` when behavior is validated, tests pass and the "Verification" section is filled with real evidence. "Looks right" is not done.

---

## Daily flow

```bash
# Start of session
git pull

# End of session — commit context together with code
git add .claude/memory/ .claude/specs/ .claude/agent-memory/
git commit -m "chore(context): update memory/specs"
git push

# Or enable auto-commit at session end (optional):
cp .claude/settings.local.json.example .claude/settings.local.json
```

---

## Useful commands

| What to do | Command |
|------------|---------|
| New team member onboarding | `/project-init` |
| Start new feature | `/spec-create [feature]` |
| Investigate and fix a bug | `/bugfix [description]` |
| Review before opening PR | `/pr-review` |
| Format commit message | `/commit` |
| Analyze code without modifying | `"use the code-reviewer agent on module [X]"` |
| Map the codebase | `"use the researcher agent for [question]"` |
| Plan a feature before coding | `"use the planner agent for [feature]"` |

---

## Existing project

Have a project with existing code and want to add this structure?

### Step 1 — Add the structure

At the root of your existing project:

```bash
gh repo clone [OWNER]/template-claude-code-open /tmp/cc-template -- --depth=1 --quiet && bash /tmp/cc-template/adopt.sh; rm -rf /tmp/cc-template
claude
```

The script adds `.claude/` and `CLAUDE.md` without touching your existing code.

### Step 2 — Run /project-adopt

```
/project-adopt
```

**What happens:** Claude uses the `researcher` agent to map the codebase before asking any questions — reads config files, git log, directory structure and existing conventions. Arrives at the interview already with answers to the obvious questions, confirming with you instead of asking from scratch.

| | `/project-init` | `/project-adopt` |
|--|----------------|-----------------|
| When to use | Blank project | Project with existing code |
| Protocol | Defines conventions | Discovers conventions |
| First action | Asks questions | Maps the codebase |
| Specs created | None (starts empty) | For in-progress features |

---

## Next steps

- Read [docs/architecture.md](docs/architecture.md) to understand how the system works
- Read [docs/customization.md](docs/customization.md) to adapt skills, agents, rules and hooks
- Read [docs/team-workflow.md](docs/team-workflow.md) if using in a team
