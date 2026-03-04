---
name: commit
description: Format and validate commit messages following Conventional Commits. Use before any git commit to ensure consistency.
disable-model-invocation: true
---

# Skill: commit

**When to use:** When formatting commit messages.

---

## Format

```
type(scope): imperative description in lowercase

[optional body: the why of the change, not the how]

[footer: breaking changes or closed issues]
```

## Types

| Type | When to use |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Change without altering external behavior |
| `docs` | Documentation |
| `test` | Tests |
| `chore` | Build, deps, config, context (`.claude/`) |
| `perf` | Performance improvement |

## Rules

- Imperative: "add feature" not "added feature"
- Maximum 72 characters on the first line
- No period at the end of description
- Scope = module or affected area (e.g.: `auth`, `orders`, `db`)
- For project context updates: `chore(context): update memory/specs`

## Examples

```
feat(auth): add JWT refresh token rotation

fix(orders): prevent race condition on concurrent updates

refactor(db): extract cursor pagination to shared util

chore(context): update lessons with Redis invalidation pattern

docs(api): add authentication endpoint examples
```
