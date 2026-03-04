---
name: project-init
description: First-session onboarding for new blank projects. Run automatically when MEMORY.md has no context. Interviews the developer and configures all memory files.
disable-model-invocation: true
---

# Skill: project-init

**When to run:** Automatically when `.claude/memory/MEMORY.md` has no context filled in. Can be invoked manually with `/project-init`.

**Objective:** Interview the developer, configure the project, and populate all memory files so any future session starts with full context — without re-explaining anything.

---

## Interview protocol

Conduct questions in sequence, one at a time. Wait for each answer before continuing. Be conversational.

### 0 — Language preference ← START HERE

Ask in both languages simultaneously, exactly once:

---
"What language do you prefer to work in?
Qual idioma você prefere para trabalhar?

**1** — English
**2** — Português"

---

From this point on, use ONLY the chosen language for all questions, responses, and generated file content.

Save the choice as `language: en` or `language: pt-br` in the MEMORY.md front matter.

---

### 1 — Identification and slug

"What will the **slug** of this project be? (unique identifier, short, no spaces — e.g.: `my-api`, `ecommerce-v2`)"

"And the full name and main objective in 1-2 sentences?"

### 2 — Tech stack

"What is the stack? (language, main frameworks, database, infrastructure/cloud)"

### 3 — Non-negotiable rules

"Are there any rules that must NEVER be broken in this project?
(e.g.: always PNPM, never alter existing migrations, PR required for main)"

### 4 — Team and language

"Is the project solo, pair, or team? How many people?"

### 5 — MCP integrations

"What external integrations are needed?
(GitHub, database, Sentry, others — or none for now)"

### 6 — Library documentation

"What are the main libs, frameworks and tools in this project that have official documentation?
(e.g.: Fastify, Prisma, React, Docker — I'll add the links in `.claude/references.md` for quick reference)"

### 7 — Initial state

"Does the project already have code or is it starting from scratch? If it already exists, briefly describe the current state."

---

## Actions after the interview

Execute in order:

1. **Fill `.claude/memory/MEMORY.md`**
   - Insert slug, repo, stack and **language** in the YAML front matter
   - Fill all sections with the collected answers
   - Write the content in the chosen language

2. **Update `CLAUDE.md`**
   - Replace `[PROJECT_NAME]` with the real project name
   - Add non-negotiable rules to the principles section

3. **Fill the "This Project" section in `.claude/references.md`**
   - For each lib/framework mentioned in question 6, add a line to the table
   - Use the official documentation URL

4. **Create `README_MCP.md`** in the root (if there are integrations)
   - List the mentioned integrations
   - Include the `claude mcp add` command for each
   - Write in the chosen language

5. **Confirm to the user** what was configured and ask if there are adjustments

6. **Commit the initialization**
   - Stage all files modified in this skill: `CLAUDE.md`, `.claude/memory/MEMORY.md`, `.claude/references.md`, and `README_MCP.md` (if created)
   - Create commit: `chore: initialize project [slug] from template`
   - Show the commit summary to the user
   - Ask if they want to push (`git push`)

7. **Prompt for next step**
   - Tell the user: "Run `/spec-create` to plan your first feature. When done, run `/project-seal` to commit the spec and finalize the transition from template to project."
