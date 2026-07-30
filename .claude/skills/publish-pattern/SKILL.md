---
name: publish-pattern
description: Publishes a reusable pattern to the user's personal cross-project pattern repo, if one is configured. Use when a solution proves genuinely reusable across other projects.
disable-model-invocation: true
---

# Skill: publish-pattern

**When to use:** When a solution proves genuinely reusable across other projects. Use judgment — only what would actually save time or prevent errors in a different context.

**Requires configuration:** this skill only does anything with GitHub if `patterns_repo` is filled in `.claude/memory/MEMORY.md`'s front matter (optional, set during `project-init` or `project-adopt`). If it's blank, skip straight to "Local-only fallback" below — never clone, create, or push to a repo the user hasn't named.

---

## Criteria to publish

Publish if the solution:
- Solved a non-obvious problem
- Is independent of this project's specific business context
- Would save time or prevent errors in another project

Don't publish:
- Solutions too specific to this project's business domain
- Temporary workarounds
- Something already in the pattern index

---

## Entry format

```markdown
### [Pattern name] — [date]
**Origin:** `[project-slug]`
**Problem:** [what it solved — 1 sentence]
**Solution:** [the approach — 2-3 sentences]
**Why it works:** [short reasoning]
**Reusable when:** [conditions or context]
**Details:** [link to the file in the source repo]
```

---

## Local-only fallback (`patterns_repo` blank)

Add the entry above to this project's `.claude/memory/patterns.md` (create it if missing) and tell the user: "No `patterns_repo` configured — recorded locally in `patterns.md` only." Stop here.

---

## Execution protocol (`patterns_repo` configured)

### Step 0 — Read the configured repo

Read `patterns_repo` from `.claude/memory/MEMORY.md`'s front matter (format `owner/repo`).

### Step 1 — Sync the local clone

Local clone path: `~/.claude/patterns-repo/`

**If it doesn't exist yet:**
```bash
git clone https://github.com/<patterns_repo> ~/.claude/patterns-repo/
```

**If it already exists:**
```bash
cd ~/.claude/patterns-repo && git pull origin main
```

Don't try to recover a non-git directory at that path — if `git pull` fails because it isn't a repo, tell the user and stop; that's their local state to fix, not this skill's job.

### Step 2 — Read the current project's slug

Read `.claude/memory/MEMORY.md` to confirm `project`.

### Step 3 — Edit the index

Open `~/.claude/patterns-repo/global-index.md` (or whatever index file the user's repo actually uses — check its README if `global-index.md` doesn't exist). Note the real path of the file you edit — it's what goes into the commit in the next step.

Add the entry under the matching category section. Create the category (`### [Category]`) if it doesn't exist yet.

Update the "last updated" date at the top of the file.

### Step 4 — Commit and push

Use the real index file path from Step 3 (don't assume `global-index.md` if the user's repo uses a different name):

```bash
cd ~/.claude/patterns-repo
git add <real-index-file>
git commit -m "docs(patterns): add [name] from [project-slug]"
git push origin main
```

### Step 5 — Record locally too

Also add a note to this project's `.claude/memory/patterns.md`, referencing the published entry.

---

## Example published entry

```markdown
### Cursor pagination on large tables — 2026-03-04
**Origin:** `my-api`
**Problem:** Offset pagination degraded past 50k rows
**Solution:** Cursor based on `(created_at, id)` with a composite index — avoids full scan
**Why it works:** The database filters from a fixed point instead of skipping N rows
**Reusable when:** Any endpoint paginating a high-volume table
**Details:** `<owner>/my-api` → `.claude/memory/lessons.md#cursor-pagination`
```

---

## Common errors

| Error | Cause | Fix |
|-------|-------|-----|
| `not a git repository` | `~/.claude/patterns-repo/` exists but isn't a git clone | Tell the user; don't auto-`git init` a path you don't own the history of |
| `Permission denied` | No GitHub auth configured for that repo | Ask the user to check their `gh`/git credentials — not this skill's problem to solve |
| `rejected — non-fast-forward` | Remote has commits not yet pulled | `git pull --rebase origin main` before pushing |
| index file not found | Repo cloned but no `global-index.md` | Ask the user what file/format their repo actually uses before inventing one |
