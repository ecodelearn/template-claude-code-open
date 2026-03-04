# Architecture — how the template works / Arquitetura — como o template funciona

## The system at a glance / O sistema em visão geral

```
template-claude-code-open/
│
├── CLAUDE.md              [1] Map — loaded every session / Mapa — carregado em toda sessão
│
└── .claude/
    ├── memory/            [2] Project memory / Memória do projeto
    ├── specs/             [3] Work state / Estado do trabalho
    ├── skills/            [4] On-demand behaviors / Comportamentos sob demanda
    ├── agents/            [5] Isolated workers / Trabalhadores isolados
    ├── rules/             [6] Path-scoped context / Contexto por caminho de arquivo
    ├── hooks/             [7] Automatic guardrails / Guardrails automáticos
    ├── agent-memory/      [8] Persistent agent knowledge / Conhecimento persistente de agents
    └── agent-memory-local/    Local agent memory / Memória local de agents (gitignored)
```

---

## 1. CLAUDE.md — the navigation map / o mapa de navegação

Loaded automatically by Claude Code in **every session**. / Carregado automaticamente em **toda sessão**. Kept intentionally minimal — every extra line costs tokens in every session for the entire life of the project. / Mantido intencionalmente mínimo — cada linha extra custa tokens em toda sessão ao longo da vida do projeto.

Contains only / Contém apenas:
- Session protocol (what to read first) / Protocolo de sessão (o que ler primeiro)
- Navigation map (where everything is) / Mapa de navegação (onde tudo está)
- Universal non-negotiable principles / Princípios inegociáveis universais

Real project rules live in `memory/MEMORY.md`. Detailed instructions live in skills and rules files. / Regras reais do projeto vivem em `memory/MEMORY.md`. Instruções detalhadas vivem em skills e rules.

---

## 2. memory/ — persistent memory / memória persistente

Four files with distinct roles / Quatro arquivos com papéis distintos:

| File / Arquivo | Role / Papel | Updated when / Atualizado quando |
|----------------|--------------|----------------------------------|
| `MEMORY.md` | Living project context — stack, team, integrations / Contexto vivo | Whenever context changes / Ao mudar o contexto |
| `lessons.md` | What worked and what didn't / O que funcionou e o que não funcionou | When discovering something relevant / Ao descobrir algo relevante |
| `decisions.md` | Architectural decisions with the why / Decisões arquiteturais com o porquê | Before significant changes / Antes de mudanças significativas |
| `patterns.md` | Efficient patterns specific to this project / Padrões eficientes | When consolidating an approach / Ao consolidar uma abordagem |

**Learning cycle / Ciclo de aprendizado:**
```
Session starts / Sessão inicia  → Claude reads MEMORY.md + INDEX.md
Work happens / Trabalho acontece → Claude checks lessons.md before technical decisions
Something discovered / Algo descoberto → Claude updates lessons.md / decisions.md / patterns.md
Next session / Próxima sessão → starts with accumulated context, without repeating errors
```

**Memory systems — what lives where / Sistemas de memória — o que fica onde:**

| System / Sistema | Location / Local | Who writes / Quem escreve | Shared via git? / Via git? |
|------------------|------------------|---------------------------|---------------------------|
| Project memory (manual) / Memória do projeto | `.claude/memory/` | Claude when instructed / Claude quando instruído | Yes / Sim |
| Auto memory (Claude's notes) / Auto-memória | `~/.claude/projects/<repo>/memory/` | Claude automatically / Claude automaticamente | No — machine-local / Não — local |
| Agent memory (project scope) / Memória de agent | `.claude/agent-memory/<agent>/` | Specific agent / Agent específico | Yes / Sim |
| Agent memory (local scope) / Memória local de agent | `.claude/agent-memory-local/<agent>/` | Specific agent / Agent específico | No — gitignored / Não |

Auto memory (`~/.claude/projects/`) is built by Claude automatically. The files in `.claude/memory/` are a separate manual system that Claude updates when explicitly instructed — they are versioned and shared with the team. / Auto-memória é construída por Claude automaticamente. Os arquivos em `.claude/memory/` são um sistema manual separado que Claude atualiza quando instruído — são versionados e compartilhados com o time.

---

## 3. specs/ — the state of work / o estado do trabalho

**`INDEX.md`** — the control panel / o painel de controle. Read at the start of every session together with `MEMORY.md`. Shows in seconds what is in progress, in backlog, blocked and done. / Lido no início de toda sessão junto com `MEMORY.md`. Mostra em segundos o que está em andamento, no backlog, bloqueado e concluído.

**`[feature-slug].md`** — one file per feature or phase / um arquivo por feature ou fase. Five key sections / Cinco seções-chave:

| Section / Seção | When to fill / Quando preencher | Purpose / Para quê serve |
|-----------------|--------------------------------|--------------------------|
| Acceptance criteria / Critérios de aceite | Before implementing / Antes de implementar | Defines what "done" means — verifiable, specific |
| Tasks / Tarefas | During implementation / Durante a implementação | Progress checklist |
| How to resume / Como retomar | Whenever pausing / Ao pausar | Any dev can continue without briefing |
| Verification / Verificação | When done / Ao concluir | Real evidence: tests, commands, results |
| Implementation notes / Notas de implementação | Continuously / Continuamente | Minor decisions, gotchas, references |

**Why specs matter for teams / Por que specs importam para times:**
```
Dev A works on feature-auth, pauses at 6pm
  → updates "How to resume" with the exact current state

Dev B (or a new session) opens the project next morning
  → git pull → reads INDEX.md → reads feature-auth.md
  → continues exactly where Dev A stopped — no briefing needed / sem briefing necessário
```

---

## 4. skills/ — on-demand behaviors / comportamentos sob demanda

Skills are directories with a `SKILL.md` entrypoint. / Skills são diretórios com um entrypoint `SKILL.md`. They load into context only when invoked — they don't consume tokens between uses. / Carregam no contexto apenas quando invocadas — não consomem tokens entre os usos.

```
.claude/skills/<skill-name>/
├── SKILL.md        ← instructions + YAML frontmatter (required / obrigatório)
├── examples/       ← example outputs (optional / opcional)
└── scripts/        ← scripts Claude can execute (optional / opcional)
```

**Frontmatter fields / Campos do frontmatter:**

| Field / Campo | Effect / Efeito |
|---------------|----------------|
| `name` | Creates the `/slash-command` / Cria o `/slash-command` |
| `description` | Claude uses this to decide when to load the skill / Claude usa para decidir quando carregar |
| `disable-model-invocation: true` | Only you can invoke it / Apenas você pode invocar — Claude não dispara automaticamente |
| `allowed-tools` | Tools available without permission prompt / Ferramentas sem prompt de permissão |
| `model` | Model override for this skill / Modelo específico para esta skill |
| `context: fork` | Runs in an isolated subagent context / Roda em contexto isolado de subagente |
| `argument-hint` | Hint shown in autocomplete / Dica mostrada no autocomplete |

**Included skills / Skills incluídas:**

| Skill | Invocation / Invocação | When to use / Quando usar |
|-------|------------------------|--------------------------|
| `/project-init` | Manual only / Apenas manual | First session — new blank project / Primeira sessão — projeto novo em branco |
| `/project-adopt` | Manual only / Apenas manual | Existing project receiving the structure / Projeto existente recebendo a estrutura |
| `/spec-create` | Manual only / Apenas manual | Start a new feature or phase / Iniciar nova feature ou fase |
| `/bugfix` | Manual only / Apenas manual | Bug report — systematic triage / Report de bug — triage sistemático |
| `/pr-review` | Manual only / Apenas manual | Before opening or reviewing a PR / Antes de abrir ou revisar um PR |
| `/commit` | Manual only / Apenas manual | Format and validate commit message / Formatar e validar mensagem de commit |
| `/deploy` | Manual only / Apenas manual | Before any deploy — never auto-triggered / Antes de qualquer deploy — nunca auto-disparado |

---

## 5. agents/ — isolated workers / trabalhadores isolados

Agents run in their own context window with a custom system prompt, specific tool access, and independent permissions. / Agents rodam em seu próprio contexto com system prompt customizado, acesso restrito a ferramentas e permissões independentes. Claude delegates to them based on the `description` field. / Claude delega para eles com base no campo `description`.

**Isolation levels / Níveis de isolamento:**

| Configuration / Configuração | Effect / Efeito |
|------------------------------|----------------|
| `tools: Read, Glob, Grep` | Read-only — cannot modify files / Somente leitura |
| `isolation: worktree` | Runs on a temporary git worktree — safe for large operations / Worktree temporária |
| `memory: project` | Writes learnings to `.claude/agent-memory/<name>/` — shared / Compartilhado com o time |
| `model: haiku` | Faster, cheaper model (good for exploration / bom para exploração) |

**Included agents / Agents incluídos:**

| Agent / Agente | Isolation / Isolamento | Memory / Memória | Purpose / Propósito |
|----------------|------------------------|------------------|---------------------|
| `code-reviewer` | worktree | — | Reviews code, never modifies / Revisa código, nunca modifica |
| `researcher` | worktree | project | Explores codebase, builds knowledge / Explora e acumula conhecimento |
| `planner` | — | — | Generates PRDs and specs / Gera PRDs e specs |

---

## 6. rules/ — path-scoped context / contexto por caminho de arquivo

Rules are markdown files in `.claude/rules/` that load automatically when Claude works with matching files. / Regras são arquivos markdown em `.claude/rules/` que carregam automaticamente quando Claude trabalha com arquivos correspondentes.

**Without rules / Sem rules (old approach / abordagem antiga):**
```
Every session / Toda sessão: CLAUDE.md + MEMORY.md + all project rules = always full token cost
```

**With rules / Com rules (path-scoped):**
```
Editing a React component: loads frontend.md only / carrega apenas frontend.md
Editing an API route:      loads api.md only / carrega apenas api.md
Editing a migration:       loads migrations.md only / carrega apenas migrations.md
Editing README:            loads nothing extra / não carrega nada extra
```

**Format / Formato:**
```markdown
---
paths:
  - "src/**/*.tsx"
  - "src/**/*.jsx"
---

# Frontend conventions / Convenções de frontend

[Rules that only apply when editing these files / Regras que se aplicam apenas ao editar estes arquivos]
```

Rules without a `paths:` field load unconditionally alongside CLAUDE.md. / Regras sem campo `paths:` carregam incondicionalmente junto com CLAUDE.md.

---

## 7. hooks/ — automatic guardrails / guardrails automáticos

Hooks fire automatically at specific lifecycle points. No invocation needed. / Hooks disparam automaticamente em pontos específicos do ciclo de vida. Sem invocação necessária.

**Four hook types / Quatro tipos de hook (official / oficiais):**

| Type / Tipo | How it works / Como funciona | Best for / Melhor para |
|-------------|------------------------------|------------------------|
| `command` | Runs a shell script / Roda um script shell | Blocking dangerous commands, formatting / Bloqueio, formatação |
| `http` | POSTs event JSON to an endpoint / POST JSON para endpoint | External integrations, logging / Integrações externas |
| `prompt` | Sends a prompt to Claude for evaluation / Prompt para Claude avaliar | Quality gates — "does this commit follow convention?" |
| `agent` | Spawns a subagent with tools / Spawna subagente com ferramentas | Complex validation that needs to read files / Validação complexa |

**Key hook events / Eventos-chave:**

| Event / Evento | When it fires / Quando dispara | Blockable / Bloqueável? |
|----------------|-------------------------------|------------------------|
| `PreToolUse` | Before any tool call / Antes de qualquer chamada de ferramenta | Yes / Sim |
| `PostToolUse` | After tool call succeeds / Após sucesso da chamada | No |
| `SessionStart` | When session begins / Ao iniciar sessão | No |
| `SessionEnd` | When session terminates / Ao encerrar sessão | No |
| `Stop` | When Claude finishes responding / Quando Claude termina | Yes / Sim |
| `UserPromptSubmit` | Before Claude processes your prompt / Antes de Claude processar | Yes / Sim |
| `SubagentStart/Stop` | Agent lifecycle / Ciclo de vida de agent | No |
| `PreCompact` | Before context compaction / Antes da compactação | No |

**Included hooks / Hooks incluídos:**

| Hook | Event / Evento | Type / Tipo | Behavior / Comportamento |
|------|----------------|-------------|--------------------------|
| `block-destructive.sh` | PreToolUse / Bash | command | Blocks rm -rf, force push, DROP TABLE... |
| `auto-format.sh` | PostToolUse / Edit+Write | command (async) | Runs formatter by file extension / Roda formatador por extensão |
| `session-end-context.sh` | SessionEnd | command | Auto-commits memory+specs (opt-in) |

---

## 8. agent-memory/ — persistent agent knowledge / conhecimento persistente de agents

When an agent has `memory: project`, it writes learnings to `.claude/agent-memory/<agent-name>/` — committed to git and shared with the team. / Quando um agent tem `memory: project`, escreve aprendizados em `.claude/agent-memory/<agent-name>/` — commitado e compartilhado com o time.

```
.claude/agent-memory/
└── researcher/
    ├── MEMORY.md         ← index, loaded at every researcher invocation / índice
    ├── architecture.md   ← codebase structure discoveries / descobertas de estrutura
    └── conventions.md    ← patterns found in the code / padrões encontrados
```

The researcher agent builds institutional knowledge over time: / O agent researcher acumula conhecimento institucional ao longo do tempo:
- First invocation: explores from scratch / Primeira invocação: explora do zero
- Later invocations: reads its own memory first / Invocações posteriores: lê a própria memória primeiro
- New team member clones: gets all accumulated knowledge / Novo membro clona: recebe todo o conhecimento acumulado

---

## Execution principles / Princípios de execução

**Stop-the-line** — when facing unexpected failure / ao enfrentar falha inesperada:
1. Stop adding code / Pare de adicionar código
2. Preserve the evidence (log, stack trace, repro steps) / Preserve as evidências
3. Re-plan with the new information / Replaneje com as novas informações

Never stack code on top of an error. / Nunca empilhe código em cima de um erro.

**Definition of Done / Definição de Pronto** — a task is only complete when / uma tarefa só está completa quando:
- Behavior satisfies the acceptance criteria in the spec / Comportamento satisfaz os critérios de aceite
- Tests passing / Testes passando
- "Verification" section filled with real evidence: command run + result / Seção "Verification" preenchida com evidência real

"Looks right" is not done. / "Parece certo" não é pronto.

---

## Token strategy / Estratégia de tokens

```
Always loaded / Sempre carregado (every session / toda sessão):
  CLAUDE.md              ~40 lines / linhas
  MEMORY.md              ~20–50 lines / linhas
  specs/INDEX.md         ~10–30 lines / linhas
  rules/ (matching path) ~20–50 lines per active rule / por regra ativa

Loaded on demand / Carregado sob demanda:
  lessons.md             only when checking approaches / só ao verificar abordagens
  decisions.md           only when planning / só ao planejar
  skills/                only when invoked / só ao invocar (/skill-name)
  agents/                only when delegated to / só ao delegar
  references.md          only before web search / só antes de web search
  agent-memory/          only when the specific agent runs / só ao rodar o agent
```

The minimal `CLAUDE.md` and path-scoped `rules/` keep the constant token cost low across the entire life of the project. / O `CLAUDE.md` mínimo e as `rules/` por caminho mantêm o custo constante de tokens baixo ao longo de toda a vida do projeto.
