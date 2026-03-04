---
name: project-adopt
description: Onboarding for existing projects receiving the Claude Code structure for the first time. Discovers conventions from the codebase before asking anything.
disable-model-invocation: true
---

# Skill: project-adopt

**When to run:** In existing projects receiving the Claude Code structure for the first time. Invoked with `/project-adopt`.

**Difference from `project-init`:**
- `project-init` → defines conventions in a blank project
- `project-adopt` → discovers conventions that already exist in the code — the codebase is the source of truth

---

## Protocol

### Phase 1 — Mapping (before asking anything)

Use the `researcher` agent to explore the project. Goal: arrive at the interview already with answers to the obvious questions, confirming with the user instead of asking from scratch.

**What to look for:**

```
Real stack:
- package.json / pyproject.toml / go.mod / Cargo.toml / pom.xml
- config files: .eslintrc, prettier.config, tsconfig.json, ruff.toml
- Docker/infra: Dockerfile, docker-compose.yml, .env.example, railway.json, vercel.json

Conventions in use:
- directory structure (src/, app/, lib/, tests/, etc.)
- import patterns in main files
- test framework and how tests are organized
- linting and formatting configuration

Current state:
- git log --oneline -20 (recent commits — what is being worked on)
- active branches (git branch -a)
- recently modified files

Existing documentation:
- README.md, docs/, CHANGELOG.md
- architecture comments in main files
```

### Phase 2 — Validation interview

Present what you found and ask for confirmation. Ask only what you couldn't infer.

```
"I mapped the project. Confirm or correct:

Detected stack: [what was found]
Identified conventions: [formatter, tests, structure]
Recent work: [summary of last commits]

A few questions I need from you:

1. What will the project slug be? (e.g.: my-api, archguard)
2. Are there non-negotiable rules not evident in the code?
   (e.g.: never alter existing migrations, PR required)
3. Is the project solo, pair, or team? Communication language?
4. MCP integrations needed? (GitHub, database, Sentry, others)
5. Are there features in progress that I should create specs for now?"
```

### Phase 3 — Actions after validation

Execute in order:

1. **Fill `.claude/memory/MEMORY.md`**
   - Use the stack and conventions *discovered* from the codebase (not the answered ones)
   - Include what is currently being worked on as "Current state"

2. **Update `CLAUDE.md`**
   - Replace `[PROJECT_NAME]` with the real name
   - Add non-negotiable rules confirmed by the user

3. **Fill `.claude/references.md`**
   - Add official links for libs identified in the mapping

4. **Create specs for in-progress work**
   - For each active branch or in-progress feature mentioned by the user
   - Use skill `/spec-create` with status `in-progress` and "How to resume" section filled

5. **Create `README_MCP.md`** if there are MCP integrations

6. **Confirm to the user** what was configured and ask if there are adjustments

---

## What NOT to do

- Don't redefine conventions that already exist in the code — discover and follow them
- Don't create specs for the entire project history — only for what is active
- Don't overwrite an existing `CLAUDE.md` without showing the diff to the user first
