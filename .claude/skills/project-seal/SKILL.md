---
name: project-seal
description: Run after the first spec-create to commit all new files and finalize the transition from template to real project. Creates a clean checkpoint in git history.
disable-model-invocation: true
---

# Skill: project-seal

**When to run:** After `project-init` + first `spec-create`. Seals the project setup with a single commit that captures all generated documentation and specs.

**Objective:** Ensure the git repository reflects the real project — not the blank template — before any implementation work begins.

---

## Protocol

### 1 — Verify prerequisites

- Check that `.claude/memory/MEMORY.md` has a non-empty `project` field (project-init was completed)
- Check that at least one spec file exists in `.claude/specs/` beyond the `_template.md` and `INDEX.md`
- If either check fails, stop and inform the user what is missing

### 2 — Show what will be committed

Run `git status` and show the user a summary of all untracked and modified files. Group them:

- **Memory & config:** `CLAUDE.md`, `.claude/memory/*.md`, `.claude/references.md`
- **Specs:** `.claude/specs/*.md` (excluding `_template.md`)
- **Other:** any remaining files at the root (e.g. `README_MCP.md`)

Ask: "These files will be committed to seal the project setup. Proceed?"

### 3 — Commit

If confirmed:

1. Stage all files shown in step 2 (prefer explicit file names over `git add .`)
2. Create commit:
   ```
   chore: seal project setup — [project-slug]

   - Configured memory, stack and rules via project-init
   - Created initial spec(s): [list spec slugs]
   - Template placeholders replaced with real project context
   ```
3. Show the commit hash and summary

### 4 — Offer push

Ask: "Push to remote? (`git push`)"

- If yes: run `git push` and confirm
- If no: remind the user to push before sharing with the team

### 5 — Done message

Confirm to the user:

> "Project sealed. Git history now reflects [project-slug], not the blank template. Any new session or team member can start from here with full context."
