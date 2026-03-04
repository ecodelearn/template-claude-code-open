# Quickstart

> New project? Follow **Steps 1–5** / Projeto novo? Siga os **Passos 1–5**.
> Existing project? Jump to **[Existing project / Projeto existente](#existing-project--projeto-existente)**

---

## Prerequisites / Pré-requisitos

- [Claude Code](https://github.com/anthropics/claude-code) installed / instalado (`npm install -g @anthropic-ai/claude-code`)
- [GitHub CLI](https://cli.github.com/) authenticated / autenticado (`gh auth login`)
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

## Step 3 — Automatic onboarding (/project-init) / Passo 3 — Onboarding automático

Claude detects that `MEMORY.md` is empty and starts `/project-init` automatically. / Claude detecta que `MEMORY.md` está vazio e inicia `/project-init` automaticamente.

First, Claude asks for your **language preference** (asked once, in both languages): / Primeiro, Claude pede sua **preferência de idioma** (perguntado uma vez, nos dois idiomas):

```
What language do you prefer to work in?
Qual idioma você prefere para trabalhar?

1 — English
2 — Português
```

From that point on, everything — questions, responses, generated files — will be in the chosen language. / A partir daí, tudo — perguntas, respostas, arquivos gerados — será no idioma escolhido.

Then you answer **7 conversational questions** — one at a time: / Em seguida você responde **7 perguntas conversacionais** — uma por vez:

| # | Question / Pergunta | Example / Exemplo |
|---|---------------------|-------------------|
| 0 | Language preference / Preferência de idioma | `1` (English) or/ou `2` (Português) |
| 1 | Project slug and name / Slug e nome do projeto | `my-api` / "B2B order REST API" |
| 2 | Tech stack / Stack tecnológica | Node.js + Fastify + PostgreSQL + Redis |
| 3 | Non-negotiable rules / Regras inegociáveis | "Always PNPM, never alter migrations" |
| 4 | Team size / Tamanho do time | "Team of 3" |
| 5 | MCP integrations / Integrações MCP | GitHub, PostgreSQL |
| 6 | Library documentation / Documentação de libs | Fastify, Prisma, Vitest |
| 7 | Initial state / Estado inicial | "Starting from scratch" |

**What is configured automatically / O que é configurado automaticamente:**
- `MEMORY.md` filled with project context / preenchido com contexto do projeto
- `CLAUDE.md` updated with the real name and rules / atualizado com nome e regras reais
- `references.md` populated with official lib links / populado com links oficiais das libs
- `README_MCP.md` created with integration setup instructions (if integrations were specified / se integrações foram especificadas)
- All files committed to git: `chore: initialize project [slug] from template`

---

## Step 4 — Create the first spec / Passo 4 — Criar a primeira spec

```
/spec-create user-authentication
```

Claude creates `.claude/specs/feature-auth.md` and updates `specs/INDEX.md`.

---

## Step 5 — Seal the project / Passo 5 — Selar o projeto

```
/project-seal
```

Commits all spec files and finalizes the transition from template to real project. After this, the git history reflects your project — not the blank template. / Commita todos os arquivos de spec e finaliza a transição do template para o projeto real. Após isso, o histórico do git reflete o seu projeto — não o template em branco.

---

## Step 6 — Start implementing / Passo 6 — Começar a implementar

```
implement the feature-auth spec
implemente a spec feature-auth
```

Claude reads the spec, checks memory and lessons, and delivers code following the project rules. / Claude lê a spec, verifica a memória e lições, e entrega código seguindo as regras do projeto.

> **Definition of Done / Definição de Pronto:** a spec is only marked as `done` when behavior is validated, tests pass and the "Verification" section is filled with real evidence. / uma spec só é marcada como `done` quando o comportamento está validado, os testes passam e a seção "Verification" está preenchida com evidência real. "Looks right" is not done. / "Parece certo" não é pronto.

---

## Daily flow / Fluxo diário

```bash
# Start of session / Início de sessão
git pull

# End of session / Fim de sessão — commit context together with code / commitar contexto junto com o código
git add .claude/memory/ .claude/specs/ .claude/agent-memory/
git commit -m "chore(context): update memory/specs"
git push

# Optional / Opcional — enable auto-commit at session end / habilitar auto-commit ao fim da sessão:
cp .claude/settings.local.json.example .claude/settings.local.json
```

---

## Useful commands / Comandos úteis

| What to do / O que fazer | Command / Comando |
|--------------------------|-------------------|
| New project onboarding / Onboarding de projeto novo | `/project-init` |
| Seal template after first spec / Selar template após primeira spec | `/project-seal` |
| Start new feature / Iniciar nova feature | `/spec-create [feature]` |
| Investigate and fix a bug / Investigar e corrigir bug | `/bugfix [description]` |
| Review before opening PR / Revisar antes de abrir PR | `/pr-review` |
| Format commit message / Formatar mensagem de commit | `/commit` |
| Analyze code without modifying / Analisar código sem modificar | `"use the code-reviewer agent on module [X]"` |
| Map the codebase / Mapear o codebase | `"use the researcher agent for [question]"` |
| Plan a feature before coding / Planejar feature antes de codar | `"use the planner agent for [feature]"` |

---

## Existing project / Projeto existente

Have a project with existing code and want to add this structure? / Tem um projeto com código existente e quer adicionar esta estrutura?

### Step 1 — Add the structure / Passo 1 — Adicionar a estrutura

At the root of your existing project / Na raiz do seu projeto existente:

```bash
gh repo clone [OWNER]/template-claude-code-open /tmp/cc-template -- --depth=1 --quiet && bash /tmp/cc-template/adopt.sh; rm -rf /tmp/cc-template
claude
```

The script adds `.claude/` and `CLAUDE.md` without touching your existing code. / O script adiciona `.claude/` e `CLAUDE.md` sem tocar no seu código.

### Step 2 — Run /project-adopt / Passo 2 — Executar /project-adopt

```
/project-adopt
```

**What happens / O que acontece:** Claude uses the `researcher` agent to map the codebase before asking any questions — reads config files, git log, directory structure and existing conventions. Arrives at the interview already with answers to the obvious questions. / Claude usa o agente `researcher` para mapear o codebase antes de perguntar qualquer coisa — lê arquivos de config, git log, estrutura e convenções existentes. Chega na entrevista já com respostas para as perguntas óbvias.

| | `/project-init` | `/project-adopt` |
|--|----------------|-----------------|
| When to use / Quando usar | Blank project / Projeto em branco | Project with existing code / Projeto com código existente |
| Protocol / Protocolo | Defines conventions / Define convenções | Discovers conventions / Descobre convenções |
| First action / Primeira ação | Asks questions / Faz perguntas | Maps the codebase / Mapeia o codebase |
| Specs created / Specs criadas | None — starts empty / Nenhuma | For in-progress features / Para features em andamento |

---

## Next steps / Próximos passos

- Read / Leia [docs/architecture.md](docs/architecture.md) — how the system works / como o sistema funciona
- Read / Leia [docs/customization.md](docs/customization.md) — adapt skills, agents, rules and hooks / adaptar skills, agents, regras e hooks
- Read / Leia [docs/team-workflow.md](docs/team-workflow.md) — if using in a team / se usar em time
