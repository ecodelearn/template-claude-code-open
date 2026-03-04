# Agents available

Invoke explicitly by name. Agents run in their own context window with isolated tools and permissions.

| Agent | File | When to use |
|-------|------|-------------|
| `code-reviewer` | `code-reviewer.md` | Review code without modifying anything — isolated worktree |
| `researcher` | `researcher.md` | Explore large repositories, map structure — isolated worktree, accumulates memory |
| `planner` | `planner.md` | Generate PRDs and implementation plans before any code |

## How to invoke

```
Use the code-reviewer agent to analyze the auth module
Use the researcher agent to map how the payment system works
Use the planner agent to create a spec for the reports feature
```

## Key frontmatter fields

| Field | Description |
|-------|-------------|
| `description` | **Critical** — the orchestrator reads only this to decide whether to delegate. Use strong keywords and "Use proactively..." |
| `tools` | Allowed tools (allowlist). Inherits all if omitted |
| `model` | `sonnet`, `opus`, `haiku`, or `inherit` |
| `isolation: worktree` | Runs in a temporary git worktree — safe for read-heavy agents |
| `memory: project` | Persistent memory at `.claude/agent-memory/<name>/` — committed to git, shared with team |
| `memory: local` | Persistent memory at `.claude/agent-memory-local/<name>/` — gitignored, machine-local |

## Memory scopes

| Scope | Location | Committed to git? |
|-------|----------|-------------------|
| `user` | `~/.claude/agent-memory/<name>/` | No |
| `project` | `.claude/agent-memory/<name>/` | Yes — shared with team |
| `local` | `.claude/agent-memory-local/<name>/` | No — gitignored |

## Adding a new agent

Create `.claude/agents/<name>.md` with YAML frontmatter + system prompt body.

Write a strong `description` — it's the only thing the orchestrator reads to decide delegation.
Use "Use proactively" if you want Claude to delegate automatically.

Reference: https://code.claude.com/docs/en/sub-agents
