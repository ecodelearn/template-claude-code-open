# template-claude-code-open

> **EN:** Claude Code base template with persistent memory, spec management, specialized skills, isolated agents, path-scoped rules and security hooks — self-contained, no external dependencies.
>
> **PT-BR:** Template base para projetos com Claude Code. Memória persistente, gestão de specs por feature, skills especializadas, agents isolados, regras por caminho e hooks de segurança — independente, sem dependências externas.

---

## The problem this template solves / O problema que este template resolve

Every time you open Claude Code in a project, it knows nothing: / Toda vez que você abre o Claude Code em um projeto, ele não sabe nada:

- What is the stack? / Qual é a stack?
- What are the team rules? / Quais são as regras do time?
- What has been tried and didn't work? / O que já foi tentado e não funcionou?
- What is being implemented right now? / O que está sendo implementado agora?

With this template, Claude answers all of this by itself before you type the first message. / Com este template, Claude responde tudo isso sozinho antes de você digitar a primeira mensagem.

## How it works / Como funciona

```
First time / Primeira vez
  → Claude detects empty MEMORY.md → runs /project-init
  → Asks: "English or Português?" — you choose once
  → All questions, responses and generated files in your language
  → Project is fully configured and committed in minutes
  → /spec-create [feature] → /project-seal → git history reflects the real project

Every session after / Toda sessão depois
  → Claude reads MEMORY.md (context, rules, language)
  → Claude reads specs/INDEX.md (what is in progress)
  → Claude checks lessons.md before any technical decision
  → Path-scoped rules load automatically for the files being edited

You request a feature / Você pede uma feature
  → /planner creates a formal plan before coding
  → /spec-create registers the spec
  → Implements following the project rules
  → Records what was learned for future sessions

Another dev (or another session) picks up the work
  → git pull → updated context + agent memory
  → Continues exactly where it stopped — no briefing needed / sem briefing
```

---

## Quick start / Início rápido

**New project / Projeto novo:**
```bash
gh repo create my-project --template [OWNER]/template-claude-code-open --clone
cd my-project && claude
# Claude detects empty MEMORY.md and starts /project-init automatically
# Claude detecta MEMORY.md vazio e inicia /project-init automaticamente
```

**Existing project / Projeto existente:**
```bash
cd my-existing-project
gh repo clone [OWNER]/template-claude-code-open /tmp/cc-template -- --depth=1 --quiet && bash /tmp/cc-template/adopt.sh; rm -rf /tmp/cc-template
claude
# Run / Execute: /project-adopt — Claude maps the codebase before asking anything
```

→ **[Full guide / Guia completo: QUICKSTART.md](QUICKSTART.md)**

---

## Structure / Estrutura

```
template-claude-code-open/
├── CLAUDE.md                         # Navigation map and session protocol / Mapa de navegação e protocolo
├── QUICKSTART.md                     # 5-minute guide / Guia em 5 minutos
├── adopt.sh                          # Adds .claude/ to existing projects / Adiciona .claude/ a projetos existentes
├── docs/
│   ├── architecture.md               # How the system works / Como o sistema funciona
│   ├── customization.md              # How to adapt to your project / Como adaptar ao seu projeto
│   └── team-workflow.md              # Remote team workflow / Workflow para times remotos
└── .claude/
    ├── settings.json                 # Shared hook config / Config de hooks compartilhada
    ├── settings.local.json.example   # Personal hooks template / Template para hooks pessoais
    ├── skills/                       # /slash-commands
    │   ├── project-init/SKILL.md     # Onboarding — new blank project / projeto novo em branco
    │   ├── project-seal/SKILL.md     # Seals template → real project in git / Sela o template no git
    │   ├── project-adopt/SKILL.md    # Onboarding — existing project / projeto existente
    │   ├── spec-create/SKILL.md      # Creates spec for new feature / Cria spec para nova feature
    │   ├── bugfix/SKILL.md           # Systematic bug triage / Triage sistemático de bugs
    │   ├── pr-review/SKILL.md        # PR checklist / Checklist de PR
    │   ├── commit/SKILL.md           # Commit message format / Formato de mensagem de commit
    │   └── deploy/SKILL.md           # Deploy checklist / Checklist de deploy
    ├── agents/
    │   ├── code-reviewer.md          # Reviews code — isolated worktree, read-only
    │   ├── researcher.md             # Explores codebase — isolated worktree, project memory
    │   └── planner.md                # Generates PRDs and plans / Gera PRDs e planos
    ├── hooks/
    │   ├── block-destructive.sh      # Blocks rm -rf, force push, DROP TABLE...
    │   ├── auto-format.sh            # Auto-formats after edits (async) / Auto-formata após edições
    │   └── session-end-context.sh    # Auto-commits memory/specs at session end (opt-in)
    ├── rules/
    │   ├── _example-frontend.md      # Template: rules for React/TS files / Regras para arquivos React/TS
    │   └── _example-api.md           # Template: rules for API/backend / Regras para API/backend
    ├── memory/
    │   ├── MEMORY.md                 # Living project context / Contexto vivo do projeto
    │   ├── lessons.md                # What worked and what didn't / O que funcionou e o que não funcionou
    │   ├── decisions.md              # Architectural decisions / Decisões arquiteturais com o porquê
    │   └── patterns.md               # Efficient patterns / Padrões eficientes do projeto
    ├── agent-memory/                 # Shared agent knowledge — committed / Conhecimento de agents — versionado
    ├── specs/
    │   ├── INDEX.md                  # Control panel — state of all features / Painel de controle
    │   └── _template.md              # Template for creating new specs / Template para novas specs
    └── references.md                 # Official docs before web search / Docs oficiais antes de web search
```

---

## Skills

| Skill | When to invoke / Quando invocar |
|-------|---------------------------------|
| `/project-init` | New project — automatic onboarding / Projeto novo — onboarding automático |
| `/project-seal` | After project-init + first spec — seals the template in git / Após project-init + primeira spec |
| `/project-adopt` | Existing project / Projeto existente |
| `/spec-create` | `/spec-create [feature]` |
| `/bugfix` | `/bugfix [description]` |
| `/pr-review` | Before opening a PR / Antes de abrir um PR |
| `/commit` | `/commit` |
| `/deploy` | Before any deploy / Antes de qualquer deploy |

## Agents / Agentes

| Agent / Agente | When to invoke / Quando invocar |
|----------------|---------------------------------|
| `code-reviewer` | `"use the code-reviewer agent on module [X]"` |
| `researcher` | `"use the researcher agent for [question]"` |
| `planner` | `"use the planner agent for [feature]"` |

## Rules / Regras (path-scoped)

Files in `.claude/rules/` with `paths:` frontmatter load automatically only when Claude works with matching files — saving context and keeping rules focused. / Arquivos em `.claude/rules/` com frontmatter `paths:` carregam automaticamente apenas quando Claude trabalha com arquivos correspondentes — economizando contexto.

---

## Team sync / Sincronização em times

Memory, specs and agent-memory are versioned files — no extra infrastructure needed. / Memória, specs e agent-memory são arquivos versionados — sem infraestrutura extra necessária.

```bash
# Start of session / Início de sessão
git pull

# End of session / Fim de sessão
git add .claude/memory/ .claude/specs/ .claude/agent-memory/
git commit -m "chore(context): update memory/specs"
git push

# Or enable auto-commit at session end / Ou habilitar auto-commit ao fim da sessão:
cp .claude/settings.local.json.example .claude/settings.local.json
```

→ **[Full team guide / Guia completo para times: docs/team-workflow.md](docs/team-workflow.md)**

---

## Documentation / Documentação

| Document / Documento | Content / Conteúdo |
|----------------------|-------------------|
| [QUICKSTART.md](QUICKSTART.md) | From zero to first code in 5 min / Do zero ao primeiro código em 5 min |
| [docs/architecture.md](docs/architecture.md) | How the system works / Como o sistema funciona internamente |
| [docs/customization.md](docs/customization.md) | How to adapt skills, agents, rules and hooks |
| [docs/team-workflow.md](docs/team-workflow.md) | Workflow for remote teams / Workflow para times remotos |

---

## License

MIT — see [LICENSE](LICENSE)
