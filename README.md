# template-claude-code-open

> **EN:** Claude Code base template with persistent memory, spec management, specialized skills, isolated agents and security hooks — self-contained, no external dependencies.
>
> **PT-BR:** Template base para projetos com Claude Code. Memória persistente, gestão de specs por feature, skills especializadas, agents isolados e hooks de segurança — independente, sem dependências externas.

---

## The problem this template solves / O problema que este template resolve

Every time you open Claude Code in a project, it knows nothing:
Toda vez que você abre o Claude Code em um projeto, ele não sabe nada:

- What is the stack? / Qual é a stack?
- What are the team rules? / Quais são as regras do time?
- What has been tried and didn't work? / O que já foi tentado e não funcionou?
- What is being implemented right now? / O que está sendo implementado agora?

With this template, Claude answers all of this by itself before you type the first message.
Com este template, Claude responde tudo isso sozinho antes de você digitar a primeira mensagem.

## How it works / Como funciona

```
First time / Primeira vez
  → Claude detects empty MEMORY.md → runs project-init
  → Asks: "English or Português?" — you choose once
  → All questions, responses and generated files in your language
  → Project is fully configured in minutes

Every session after / Toda sessão depois
  → Claude reads MEMORY.md (context, rules and your language)
  → Claude reads specs/INDEX.md (what is in progress)
  → Claude checks lessons.md before any technical decision

You request a feature / Você pede uma feature
  → Claude creates a formal spec before coding
  → Implements following the project rules
  → Records what was learned for future sessions

Another dev (or another session) picks up the work
  → git pull → updated context
  → Continues exactly where it stopped — no briefing needed
```

---

## Quick start / Início rápido

**New project / Projeto novo:**
```bash
gh repo create my-project --template [OWNER]/template-claude-code-open --clone
cd my-project && claude
# Claude detects empty MEMORY.md and starts project-init automatically
# Claude detecta MEMORY.md vazio e inicia project-init automaticamente
```

**Existing project / Projeto existente:**
```bash
cd my-existing-project
gh repo clone [OWNER]/template-claude-code-open /tmp/cc-template -- --depth=1 --quiet && bash /tmp/cc-template/adopt.sh; rm -rf /tmp/cc-template
claude
# Run / Execute: "project-adopt" — Claude maps the codebase before asking anything
```

→ **[Full guide / Guia completo: QUICKSTART.md](QUICKSTART.md)**

---

## Structure / Estrutura

```
template-claude-code-open/
├── CLAUDE.md                    # Navigation map and session protocol (bilingual)
├── QUICKSTART.md                # 5-minute guide (bilingual)
├── adopt.sh                     # Adds .claude/ structure to existing projects
├── docs/
│   ├── architecture.md          # How the system works internally
│   ├── customization.md         # How to adapt to your project
│   └── team-workflow.md         # Remote team workflow
└── .claude/
    ├── settings.json            # Hook configuration
    ├── skills/
    │   ├── project-init.md      # Onboarding — new blank project
    │   ├── project-adopt.md     # Onboarding — existing project (discovers code conventions)
    │   ├── spec-create.md       # Creates spec for new feature or phase
    │   ├── bugfix.md            # Systematic bug triage (reproduce→fix→verify)
    │   ├── pr-review.md         # PR opening and review checklist
    │   ├── commit.md            # Standardized commit message format
    │   └── deploy.md            # Deploy checklist and procedure
    ├── agents/
    │   ├── code-reviewer.md     # Reviews code without modifying anything (read-only)
    │   ├── researcher.md        # Explores large repositories, maps structure
    │   └── planner.md           # Generates PRDs and plans before any code
    ├── hooks/
    │   ├── block-destructive.sh # Blocks rm -rf, force push, DROP TABLE, etc.
    │   └── auto-format.sh       # Auto-formats after edits
    ├── memory/
    │   ├── MEMORY.md            # Living project context (read every session)
    │   ├── lessons.md           # What worked and what didn't
    │   ├── decisions.md         # Architectural decisions with the why
    │   └── patterns.md          # Efficient patterns specific to the project
    ├── specs/
    │   ├── INDEX.md             # Control panel — state of all features
    │   └── _template.md         # Template for creating new specs
    └── references.md            # Official docs to check before web search
```

---

## Available skills / Skills disponíveis

| Skill | When to invoke / Quando invocar |
|-------|---------------------------------|
| `project-init` | New project — automatic onboarding / Projeto novo — onboarding automático |
| `project-adopt` | Existing project — "execute project-adopt" |
| `spec-create` | `"use skill spec-create for [feature]"` |
| `bugfix` | `"use skill bugfix for [description]"` |
| `pr-review` | `"follow the pr-review checklist"` |
| `commit` | `"use skill commit"` |
| `deploy` | `"use skill deploy"` |

## Available agents / Agents disponíveis

| Agent | When to invoke / Quando invocar |
|-------|---------------------------------|
| `code-reviewer` | `"use the code-reviewer agent on module [X]"` |
| `researcher` | `"use the researcher agent for [question]"` |
| `planner` | `"use the planner agent for [feature]"` |

---

## Team sync / Sincronização em times

Memory and specs are versioned files — no extra infrastructure needed.
Memória e specs são arquivos versionados normalmente — sem infraestrutura extra.

```bash
# Start of session / Início de sessão
git pull

# End of session / Fim de sessão
git add .claude/memory/ .claude/specs/
git commit -m "chore(context): update memory/specs"
git push
```

→ **[Full team guide / Guia completo para times: docs/team-workflow.md](docs/team-workflow.md)**

---

## Documentation / Documentação

| Document | Content |
|----------|---------|
| [QUICKSTART.md](QUICKSTART.md) | From zero to first code in 5 minutes |
| [docs/architecture.md](docs/architecture.md) | How the system works internally |
| [docs/customization.md](docs/customization.md) | How to adapt skills, agents and hooks |
| [docs/team-workflow.md](docs/team-workflow.md) | Workflow for remote teams |

---

## License

MIT — see [LICENSE](LICENSE)
