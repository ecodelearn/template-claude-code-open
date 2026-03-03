# Architecture — how the template works / Arquitetura — como o template funciona

## The five pillars / Os cinco pilares

```
template-claude-code-open/
│
├── CLAUDE.md          [1] The map — loaded every session / O mapa — carregado em toda sessão
│
└── .claude/
    ├── memory/        [2] The memory — what the project learned / A memória — o que o projeto aprendeu
    ├── specs/         [3] The specs — the state of work / As specs — o estado do trabalho
    ├── skills/        [4] The skills — on-demand behaviors / As skills — comportamentos sob demanda
    ├── agents/        [5] The agents — isolated workers / Os agentes — trabalhadores isolados
    └── hooks/         [6] The hooks — automatic guardrails / Os hooks — guardrails automáticos
```

---

## 1. CLAUDE.md — the navigation map / o mapa de navegação

Loaded automatically by Claude Code in **every session**. That's why it's kept minimal — just navigation and protocol.

Does not contain project rules. Contains only / Contém apenas:
- Session protocol (what to read first)
- Map of where everything is
- Universal non-negotiable principles

Real project rules live in `memory/MEMORY.md`.

---

## 2. memory/ — persistent memory / memória persistente

Four files with distinct roles / Quatro arquivos com papéis distintos:

| File / Arquivo | Role / Papel | Updated when / Atualizado quando |
|----------------|--------------|----------------------------------|
| `MEMORY.md` | Living project context | Whenever the state changes |
| `lessons.md` | What worked and what didn't | When discovering something relevant |
| `decisions.md` | Architectural decisions with the why | Before implementing significant changes |
| `patterns.md` | Efficient patterns specific to the project | When consolidating an approach |

**Learning cycle / Ciclo de aprendizado:**
```
Session starts → Claude reads MEMORY.md + INDEX.md
Work happens → Claude checks lessons.md before deciding
Something is discovered → Claude updates lessons.md, decisions.md or patterns.md
Next session → starts with accumulated context, without repeating errors
```

---

## 3. specs/ — the state of work / o estado do trabalho

Two pieces / Duas peças:

**`INDEX.md`** — the control panel. Read at the start of every session together with `MEMORY.md`. Shows in seconds what is in progress, in backlog, blocked and done.

**`[feature-slug].md`** — one file per feature or phase. Contains five key sections:

| Section / Seção | When to fill / Quando preencher | Purpose / Para quê serve |
|-----------------|----------------------------------|--------------------------|
| Acceptance criteria | Before implementing | Defines what is "done" — verifiable and specific |
| Tasks | During implementation | Progress checklist |
| How to resume | Whenever pausing | Allows any dev to continue without briefing |
| Verification | When done | Real evidence that it works (tests, commands, results) |
| Implementation notes | Continuously | Minor decisions, gotchas, references |

**Why this is powerful for teams / Por que isso é poderoso para times:**
```
Dev A works on feature-auth, pauses at 6pm
  → updates "How to resume" in the spec with the exact state

Dev B (or new session) opens the project next morning
  → git pull → reads INDEX.md → reads feature-auth.md → knows exactly where to continue
```

---

## 4. skills/ — on-demand behaviors / comportamentos sob demanda

Skills are markdown files that teach Claude to execute specific tasks in a standardized way. They are only loaded when invoked — they don't consume tokens the rest of the time.

**Included skills / Skills incluídas:**

| Skill | When to use / Quando usar |
|-------|---------------------------|
| `project-init` | Onboarding of new blank project |
| `project-adopt` | Onboarding of existing project — discovers code conventions |
| `spec-create` | Creates a new spec for a feature |
| `bugfix` | Systematic bug triage — reproduce → locate → fix → verify |
| `pr-review` | Checklist before opening or reviewing PR |
| `commit` | Standardized commit message format |
| `deploy` | Deploy checklist and procedure |

**Difference between `project-init` and `project-adopt` / Diferença entre `project-init` e `project-adopt`:**
- `project-init` → blank project → defines conventions via interview
- `project-adopt` → code already exists → uses the `researcher` agent to discover stack, conventions and in-progress work before asking any questions

---

## 5. agents/ — isolated workers / trabalhadores isolados

Agents only have access to the tools defined in their file. This ensures that / Isso garante que:
- `code-reviewer` **never modifies** files — only reads and analyzes
- `researcher` **never modifies** files — only explores and maps
- `planner` **never writes production code** — only generates documents

**Why isolation matters / Por que isolamento importa:**
A review agent with full access could "help" by modifying the code it is reviewing. Isolation ensures separation of responsibilities.

---

## 6. hooks/ — automatic guardrails / guardrails automáticos

Two hooks that run without needing to be invoked / Dois hooks que rodam sem precisar ser invocados:

**`block-destructive.sh`** (PreToolUse)
- Intercepts every Bash command before executing
- Blocks: `rm -rf`, `git push --force`, `DROP TABLE`, `chmod -R 777`, etc.
- Exit code 2 = command blocked with explanatory message

**`auto-format.sh`** (PostToolUse)
- Runs after each file edit (Edit or Write)
- Detects the extension and applies the available formatter
- Supports: prettier (JS/TS), ruff/black (Python), gofmt (Go), rustfmt (Rust), shfmt (Bash)
- Silent failure if formatter is not installed

---

## Execution principles / Princípios de execução

**Stop-the-line** — when facing unexpected failure (breaking test, wrong behavior, build error):
1. Stop adding code
2. Preserve the evidence (log, stack trace, repro steps)
3. Re-plan with the new information

The goal is not to stack code on top of an error. A problem ignored in the middle of the work becomes two problems at the end.

**Definition of Done** — a task is only complete when:
- Behavior satisfies the acceptance criteria of the spec
- Tests passing (or documented reason for not having run)
- "Verification" section of the spec has real evidence: command run + result

"Looks right" is not done.

---

## Token strategy / Estratégia de tokens

The system is designed to be economical / O sistema é desenhado para ser econômico:

```
Always loaded (every session) / Sempre carregado (toda sessão):
  CLAUDE.md         ~40 lines
  MEMORY.md         ~20-40 lines (grows with the project)
  specs/INDEX.md    ~10-30 lines (depends on number of features)

Loaded on demand / Carregado sob demanda:
  lessons.md        only when checking approaches
  decisions.md      only when planning changes
  skills/           only when invoked
  agents/           only when invoked
  references.md     only before web search
```

The minimal `CLAUDE.md` is intentional: every extra line costs tokens in **every session** throughout the life of the project.
