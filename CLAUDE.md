# [PROJECT_NAME]

> Senior software engineer. Simple and direct solutions. No over-engineering.
> Engenheiro de software pleno. Soluções simples e diretas. Sem over-engineering.

## Mandatory protocol — every session / Protocolo obrigatório — toda sessão

1. Read `.claude/memory/MEMORY.md` — check the `language` field and use it for ALL responses in this session
2. Read `.claude/specs/INDEX.md` — current state of all features/phases
3. Check `.claude/memory/lessons.md` before any technical decision
4. If `MEMORY.md` has no context → run skill `project-init` immediately (first question: language preference)
5. When pausing or finishing work → update the corresponding spec and `INDEX.md`
6. When discovering something relevant → record in `lessons.md`, `decisions.md` or `patterns.md`

## Language rule / Regra de idioma

- If `language: en` in MEMORY.md → respond and write everything in **English**
- If `language: pt-br` in MEMORY.md → respond and write everything in **Português**
- If `language` field is empty or not set → ask for preference before doing anything else

## Navigation map / Mapa de navegação

| I need / Preciso de | Where / Onde |
|---------------------|--------------|
| Context, stack and rules | `.claude/memory/MEMORY.md` |
| Feature and sprint state | `.claude/specs/INDEX.md` |
| What worked / errors to avoid | `.claude/memory/lessons.md` |
| Architectural decisions and why | `.claude/memory/decisions.md` |
| Efficient project patterns | `.claude/memory/patterns.md` |
| Spec for a specific feature | `.claude/specs/[feature-slug].md` |
| Available skills and when to use | `.claude/skills/README.md` |
| Specialized agents | `.claude/agents/README.md` |
| Official docs before web search | `.claude/references.md` |

## Non-negotiable principles / Princípios inegociáveis

- Always prefer the simplest solution that solves the problem
- Never repeat errors documented in `lessons.md`
- Record important decisions in `decisions.md` with the why
- Update specs and `INDEX.md` when pausing any work
- Code belongs to the team — any session must be able to continue another's work
- Before web search, check `.claude/references.md` — official sources take priority
- **Stop-the-line:** when facing unexpected failure, stop, preserve evidence, re-plan — don't stack code on top of an error
- **Definition of Done:** validated behavior + passing tests + verification documented in spec — "looks right" is not done
