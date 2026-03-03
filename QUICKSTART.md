# Quickstart

> New project? Follow **Steps 1–5** / Projeto novo? Siga os **Passos 1–5**.
> Existing project? Jump to **[Existing project](#existing-project--projeto-existente)** / Projeto existente? Vá para **[Projeto existente](#existing-project--projeto-existente)**.

---

## Prerequisites / Pré-requisitos

- [Claude Code](https://github.com/anthropics/claude-code) installed (`npm install -g @anthropic-ai/claude-code`)
- [GitHub CLI](https://cli.github.com/) authenticated (`gh auth login`)
- Git configured / Git configurado

---

## Step 1 — Create the project from the template / Passo 1 — Criar o projeto a partir do template

```bash
gh repo create my-project --template [OWNER]/template-claude-code-open --clone
cd my-project
```

> Manual clone / Clonar manualmente:
> ```bash
> git clone https://github.com/[OWNER]/template-claude-code-open.git my-project
> cd my-project
> rm -rf .git && git init
> gh repo create my-project --source=. --push
> ```

---

## Step 2 — Open Claude Code / Passo 2 — Abrir o Claude Code

```bash
claude
```

---

## Step 3 — Automatic onboarding (project-init) / Passo 3 — Onboarding automático

Claude detects that `MEMORY.md` is empty and starts `project-init` automatically.
Claude detecta que `MEMORY.md` está vazio e inicia o `project-init` automaticamente.

First, Claude asks for your **language preference** (asked once, in both languages):

```
What language do you prefer to work in?
Qual idioma você prefere para trabalhar?

1 — English
2 — Português
```

From that point on, everything — questions, responses, generated files — will be in the chosen language.
A partir daí, tudo — perguntas, respostas, arquivos gerados — será no idioma escolhido.

Then you answer **7 conversational questions** — one at a time:

| # | Question | Example |
|---|----------|---------|
| 0 | **Language preference** | `1` (English) or `2` (Português) |
| 1 | Project slug and name | `my-api` / "B2B order REST API" |
| 2 | Tech stack | Node.js + Fastify + PostgreSQL + Redis |
| 3 | Non-negotiable rules | "Always PNPM, never alter migrations" |
| 4 | Team size | "Team of 3" |
| 5 | MCP integrations | GitHub, PostgreSQL |
| 6 | Library documentation | Fastify, Prisma, Vitest |
| 7 | Initial state | "Starting from scratch" |

**What is configured automatically:**
- `MEMORY.md` filled with project context (in chosen language)
- `CLAUDE.md` updated with the real name and rules
- `references.md` populated with the links for the reported libs
- `README_MCP.md` created with integration setup instructions (if integrations were specified)

---

## Step 4 — Create the first spec / Passo 4 — Criar a primeira spec

```
"use skill spec-create for the JWT authentication feature"
"use a skill spec-create para a feature de autenticação JWT"
```

Claude creates `.claude/specs/feature-auth.md` and updates `specs/INDEX.md`.

---

## Step 5 — Start implementing / Passo 5 — Começar a implementar

```
"implement the feature-auth spec"
"implemente a spec feature-auth"
```

Claude reads the spec, checks the memory and lessons, and delivers code following the project rules.

> **Definition of Done:** a spec is only marked as `done` when the behavior is validated, tests are passing and the "Verification" section of the spec is filled with real evidence. "Looks right" is not done.

---

## Daily flow / Fluxo diário

```bash
# Start of day or session — get updated team context
# Início do dia ou sessão — pegar contexto atualizado do time
git pull

# During work / Durante o trabalho
# Claude updates specs and memory automatically throughout the session

# End of day — commit context together with code
# Fim do dia — commita o contexto junto com o código
git add .claude/memory/ .claude/specs/
git commit -m "chore(context): update memory/specs"
git push
```

---

## Useful commands in Claude Code / Comandos úteis no Claude Code

| What to do / O que fazer | What to type / O que digitar |
|--------------------------|------------------------------|
| New team member / Novo membro no time | `"execute project-init"` |
| Start new feature / Iniciar nova feature | `"use skill spec-create for [feature]"` |
| Investigate and fix a bug | `"use skill bugfix for [bug description]"` |
| Review before opening PR | `"follow the pr-review checklist"` |
| Format commit message | `"use skill commit"` |
| Analyze code without modifying | `"use the code-reviewer agent on module [X]"` |
| Map the codebase | `"use the researcher agent for [question]"` |
| Plan a feature | `"use the planner agent for [feature]"` |

---

## Existing project / Projeto existente

Have a project with existing code and want to add this structure?
Tem um projeto com código já existente e quer adicionar esta estrutura?

### Step 1 — Add the structure to the project / Passo 1 — Adicionar a estrutura ao projeto

At the root of your existing project / Na raiz do seu projeto existente:

```bash
gh repo clone [OWNER]/template-claude-code-open /tmp/cc-template -- --depth=1 --quiet && bash /tmp/cc-template/adopt.sh; rm -rf /tmp/cc-template
claude
```

The script adds `.claude/` and `CLAUDE.md` without touching your existing code.
O script adiciona o `.claude/` e o `CLAUDE.md` sem tocar no seu código.

### Step 2 — Run project-adopt / Passo 2 — Executar project-adopt

```
"execute project-adopt"
```

**What happens / O que acontece:** Claude uses the `researcher` agent to map the codebase before asking any questions — reads config files, git log, directory structure and existing conventions. Arrives at the interview already with answers to the obvious questions, confirming with you instead of asking from scratch.

**Difference from `project-init` / Diferença do `project-init`:**

| | `project-init` | `project-adopt` |
|--|----------------|-----------------|
| When to use / Quando usar | Blank project / Projeto em branco | Project with existing code / Projeto com código existente |
| Protocol / Protocolo | Defines conventions / Define convenções | Discovers conventions / Descobre convenções |
| First action / Primeira ação | Asks questions / Faz perguntas | Maps the codebase / Mapeia o codebase |
| Specs created / Specs criadas | None (starts empty) / Nenhuma (começa vazio) | For in-progress features / Para features em andamento |

---

## Next steps / Próximos passos

- Read [docs/architecture.md](docs/architecture.md) to understand how the system works
- Read [docs/customization.md](docs/customization.md) to adapt skills, agents and hooks to your project
- Read [docs/team-workflow.md](docs/team-workflow.md) if using in a team
