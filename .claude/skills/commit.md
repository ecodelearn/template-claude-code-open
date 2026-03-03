# Skill: commit

**When to use / Quando usar:** When formatting commit messages.

---

## Format / Formato

```
type(scope): imperative description in lowercase

[optional body: the why of the change, not the how]

[footer: breaking changes or closed issues]
```

## Types / Tipos

| Type / Tipo | When to use / Quando usar |
|-------------|---------------------------|
| `feat` | New feature / Nova funcionalidade |
| `fix` | Bug fix / Correção de bug |
| `refactor` | Change without altering external behavior / Mudança sem alterar comportamento externo |
| `docs` | Documentation / Documentação |
| `test` | Tests / Testes |
| `chore` | Build, deps, config, context (`.claude/`) |
| `perf` | Performance improvement / Melhoria de performance |

## Rules / Regras

- Imperative: "add feature" not "added feature"
- Maximum 72 characters on the first line
- No period at the end of description
- Scope = module or affected area (e.g.: `auth`, `orders`, `db`)
- For project context updates: `chore(context): update memory/specs`

## Examples / Exemplos

```
feat(auth): add JWT refresh token rotation

fix(orders): prevent race condition on concurrent updates

refactor(db): extract cursor pagination to shared util

chore(context): update lessons with Redis invalidation pattern

docs(api): add authentication endpoint examples
```
