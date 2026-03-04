# Customization — adapting the template to your project / Customização — adaptando o template ao seu projeto

## Adding a skill / Adicionando uma skill

Create a directory with a `SKILL.md` entrypoint / Crie um diretório com um entrypoint `SKILL.md`:

```bash
mkdir -p .claude/skills/my-skill
```

`SKILL.md` with frontmatter / com frontmatter:

```markdown
---
name: my-skill
description: What this skill does and when Claude should use it. Be specific. / O que esta skill faz e quando Claude deve usá-la. Seja específico.
disable-model-invocation: true
argument-hint: "[optional-argument]"
---

# Skill: my-skill

## When to use / Quando usar
[Describe the exact situation / Descreva a situação exata]

## Steps / Passos
1. [Step 1]
2. [Step 2]

## Expected output / Saída esperada
[Show a concrete example / Mostre um exemplo concreto]
```

Add to `.claude/skills/README.md` / Adicione ao `README.md`:
```markdown
| `/my-skill` | `my-skill/` | [when to use — 1 sentence / quando usar] |
```

**Frontmatter decisions / Decisões de frontmatter:**

| I want / Quero... | Use / Use |
|-------------------|-----------|
| Only I can run it (deploy, commit, sensitive) / Só eu posso executar | `disable-model-invocation: true` |
| Claude can also trigger automatically / Claude também pode disparar | omit / omita `disable-model-invocation` |
| Skill runs in isolated context / Roda em contexto isolado | `context: fork` |
| Restrict tools available / Restringir ferramentas disponíveis | `allowed-tools: Read, Grep` |
| Use a specific model / Usar modelo específico | `model: haiku` |

**Supporting files / Arquivos de suporte** — keep SKILL.md focused / mantenha SKILL.md focado:

```
.claude/skills/deploy/
├── SKILL.md            ← overview + "see checklist.md for details"
├── checklist.md        ← detailed checklist / checklist detalhado
└── scripts/
    └── pre-deploy.sh   ← Claude can execute this / Claude pode executar isso
```

Reference supporting files from SKILL.md so Claude knows they exist. / Referencie os arquivos de suporte no SKILL.md para que Claude saiba que existem.

Reference: https://code.claude.com/docs/en/skills

---

## Adding path-scoped rules / Adicionando regras por caminho

Rules in `.claude/rules/` load automatically when Claude works with matching files. / Regras em `.claude/rules/` carregam automaticamente quando Claude trabalha com arquivos correspondentes. They don't consume tokens when irrelevant. / Não consomem tokens quando irrelevantes.

Create `.claude/rules/my-rules.md` / Crie o arquivo:

```markdown
---
paths:
  - "src/**/*.ts"
  - "src/**/*.tsx"
---

# TypeScript conventions / Convenções TypeScript

- Use explicit return types on all public functions / Use tipos de retorno explícitos em funções públicas
- Prefer `type` over `interface` for object shapes / Prefira `type` a `interface`
- No `any` — use `unknown` and narrow with type guards / Sem `any`
```

**When to use rules vs CLAUDE.md / Quando usar rules vs CLAUDE.md:**

| Content type / Tipo de conteúdo | Where it goes / Onde vai |
|---------------------------------|--------------------------|
| Universal project rules (always relevant) / Regras universais | `CLAUDE.md` non-negotiable principles |
| Stack-specific conventions / Convenções específicas de stack | `.claude/rules/` with `paths:` |
| Detailed technical reference / Referência técnica detalhada | `memory/patterns.md` or `decisions.md` |
| Task instructions / Instruções de tarefa | `.claude/skills/` |

**Common path patterns / Padrões de caminho comuns:**

```yaml
# React/TypeScript frontend / Frontend
paths:
  - "src/**/*.{ts,tsx}"

# Backend API
paths:
  - "src/api/**"
  - "src/routes/**"

# Database / migrations / Banco de dados
paths:
  - "db/migrations/**"
  - "prisma/schema.prisma"

# Tests / Testes
paths:
  - "**/*.test.{ts,js}"
  - "tests/**"
```

Rules without `paths:` load unconditionally alongside CLAUDE.md. / Regras sem `paths:` carregam incondicionalmente junto com CLAUDE.md.

Reference: https://code.claude.com/docs/en/memory#organize-rules-with-clauderules

---

## Adding an agent / Adicionando um agente

Create `.claude/agents/my-agent.md` / Crie o arquivo:

```markdown
---
name: my-agent
description: What this agent does. Use proactively when [specific situation]. / O que este agent faz. Use proativamente quando [situação específica].
tools: Read, Glob, Grep
model: sonnet
---

# Agent: my-agent

[System prompt — what the agent is and how it should behave / O que o agent é e como deve se comportar]
```

**Critical: the `description` field / Crítico: o campo `description`**

The orchestrator (main Claude) reads **only the description** to decide whether to delegate. / O orquestrador (Claude principal) lê **apenas a description** para decidir se delega.

```yaml
# Weak — Claude may not delegate when appropriate / Fraco
description: "Helps with database queries"

# Strong — Claude knows exactly when to call this / Forte
description: "Expert SQL analyst. Use proactively when analyzing data,
writing queries, or diagnosing database performance issues."
```

**Isolation and memory / Isolamento e memória:**

| Scenario / Cenário | Configuration / Configuração |
|--------------------|------------------------------|
| Read-only agent (reviewer, explorer) / Somente leitura | `tools: Read, Glob, Grep` |
| Safe isolation — won't touch working files / Isolamento seguro | `isolation: worktree` |
| Build knowledge across sessions (shared) / Acumular conhecimento compartilhado | `memory: project` |
| Build knowledge (personal) / Conhecimento pessoal | `memory: local` |
| Use faster/cheaper model / Modelo mais rápido | `model: haiku` |
| Full access / Acesso total | omit `tools` (inherits all) |

**Example — domain-specific agent / Exemplo — agente de domínio:**

```markdown
---
name: security-reviewer
description: Security specialist. Use proactively after any auth, payment,
or user-data changes. Reviews for OWASP vulnerabilities, injection, secrets exposure.
tools: Read, Glob, Grep
model: sonnet
isolation: worktree
---

You are a security engineer. Review code for:
- SQL/command injection vulnerabilities
- Hardcoded secrets or credentials
- Missing input validation at system boundaries
- Insecure direct object references
- Missing rate limiting on sensitive endpoints

Report format: Critical (must fix) → Warning (should fix) → Informational
```

Reference: https://code.claude.com/docs/en/sub-agents

---

## Modifying hooks / Modificando os hooks

### Add a blocked pattern / Adicionar um padrão bloqueado

In `.claude/hooks/block-destructive.sh`, add to the `BLOCKED` array / adicione ao array `BLOCKED`:

```bash
BLOCKED=(
    # existing patterns / padrões existentes...
    "my-dangerous-command"
)
```

### Add a formatter / Adicionar um formatador

In `.claude/hooks/auto-format.sh`, add a `case` entry / adicione um case:

```bash
case "$EXT" in
    # existing cases / cases existentes...
    lua)
        command -v stylua &>/dev/null && stylua "$FILE" 2>/dev/null
        ;;
esac
```

### Create a new command hook / Criar um hook de comando

1. Create `.claude/hooks/my-hook.sh`
2. `chmod +x .claude/hooks/my-hook.sh`
3. Register in `.claude/settings.json` / Registre:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/my-hook.sh"
          }
        ]
      }
    ]
  }
}
```

**Correct PreToolUse output format / Formato correto de saída para PreToolUse:**

```bash
#!/usr/bin/env bash
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if echo "$COMMAND" | grep -q "my-pattern"; then
    jq -n --arg reason "Blocked: reason / Bloqueado: motivo" '{
        hookSpecificOutput: {
            hookEventName: "PreToolUse",
            permissionDecision: "deny",
            permissionDecisionReason: $reason
        }
    }'
    exit 0  # exit 0 with JSON output — NOT exit 2
fi

exit 0  # allow / permitir
```

### Create a prompt hook (AI-evaluated gate) / Hook de prompt (portão avaliado por IA)

For quality gates that require judgment / Para portões de qualidade que exigem julgamento:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "The user is about to run: $ARGUMENTS\n\nIf this is a `git commit` command, check if the message follows Conventional Commits (type(scope): description, types: feat/fix/refactor/docs/test/chore/perf, max 72 chars first line).\n\nReturn JSON: {\"decision\": \"allow\"} if valid or not a commit. {\"decision\": \"block\", \"reason\": \"explanation\"} if the message is invalid.",
            "model": "haiku"
          }
        ]
      }
    ]
  }
}
```

### Personal hooks / Hooks pessoais (`settings.local.json`)

Personal hooks that shouldn't be shared / Hooks pessoais que não devem ser compartilhados:

```bash
cp .claude/settings.local.json.example .claude/settings.local.json
# Edit to enable SessionEnd auto-commit or add your own hooks
# Edite para habilitar auto-commit no SessionEnd ou adicionar seus próprios hooks
```

**Available events / Eventos disponíveis:** `SessionStart`, `SessionEnd`, `PreToolUse`, `PostToolUse`, `PostToolUseFailure`, `Stop`, `UserPromptSubmit`, `SubagentStart`, `SubagentStop`, `Notification`, `PreCompact`

Reference: https://code.claude.com/docs/en/hooks

---

## Configuring agent memory / Configurando memória de agent

Agents with `memory: project` maintain persistent knowledge across sessions. / Agents com `memory: project` mantêm conhecimento persistente entre sessões.

**Enable memory on an existing agent / Habilitar memória em um agent existente:**

```yaml
---
name: code-reviewer
memory: project
---
```

**Instruct the agent to use its memory / Instrua o agent a usar a memória:**

```markdown
## Memory usage / Uso da memória

Before starting any review / Antes de iniciar qualquer revisão:
1. Read your agent memory for patterns discovered / Leia sua memória para padrões descobertos
2. Apply accumulated knowledge to the current review / Aplique o conhecimento acumulado

After completing a review / Após concluir:
- Update agent memory with new patterns / Atualize a memória com novos padrões
- Note recurring issues across the codebase / Registre problemas recorrentes
```

**Memory scopes / Escopos de memória:**

| Scope / Escopo | Path / Caminho | Use when / Usar quando |
|----------------|----------------|------------------------|
| `project` | `.claude/agent-memory/<name>/` | Knowledge is project-specific and useful to the team / Conhecimento específico do projeto, útil para o time |
| `local` | `.claude/agent-memory-local/<name>/` | Personal workflow or machine-specific / Fluxo pessoal ou específico da máquina |
| `user` | `~/.claude/agent-memory/<name>/` | Knowledge applies across all projects / Conhecimento para todos os projetos |

Reference: https://code.claude.com/docs/en/sub-agents#enable-persistent-memory

---

## Customizing CLAUDE.md / Customizando o CLAUDE.md

CLAUDE.md is loaded every session — keep it lean. / CLAUDE.md é carregado em toda sessão — mantenha-o enxuto.

**What goes in CLAUDE.md / O que vai no CLAUDE.md:**
- Session protocol / Protocolo de sessão
- Navigation map / Mapa de navegação
- Absolute non-negotiable rules (max 5-7) / Regras inegociáveis absolutas

**What does NOT go in CLAUDE.md / O que NÃO vai no CLAUDE.md:**

| Content / Conteúdo | Where it belongs / Onde vai |
|--------------------|----------------------------|
| Detailed technical rules / Regras técnicas detalhadas | `.claude/rules/` with `paths:` |
| Stack-specific conventions / Convenções de stack | `.claude/rules/frontend.md`, `api.md`, etc. |
| Decisions and history / Decisões e histórico | `memory/decisions.md` |
| What worked/failed / O que funcionou/falhou | `memory/lessons.md` |
| Task instructions / Instruções de tarefa | `.claude/skills/` |

**Target / Meta:** CLAUDE.md under 50 lines. / CLAUDE.md abaixo de 50 linhas. Every extra line is paid in tokens in every session. / Cada linha extra é paga em tokens em toda sessão.

---

## Adding lib references / Adicionando referências de libs

When adding a new lib, add its documentation to `.claude/references.md` / Ao adicionar uma nova lib, adicione sua documentação:

```markdown
## This Project / Deste Projeto

| Resource | URL | When to use / Quando usar |
|----------|-----|--------------------------|
| Fastify | https://fastify.dev/docs/latest/ | Routes, plugins, lifecycle |
| Prisma | https://www.prisma.io/docs | Schema, migrations, queries |
| My new lib | https://docs.mynewlib.com | [when to consult / quando consultar] |
```

Claude checks this file before web search. / Claude consulta este arquivo antes de web search.

---

## Adopting the template in an existing project / Adotando o template em projeto existente

```bash
# At the root of the existing project / Na raiz do projeto existente
gh repo clone [OWNER]/template-claude-code-open /tmp/cc-template -- --depth=1 --quiet \
  && bash /tmp/cc-template/adopt.sh; rm -rf /tmp/cc-template
```

Then open Claude Code and run `/project-adopt`. / Depois abra o Claude Code e execute `/project-adopt`.

**What `adopt.sh` copies / O que o `adopt.sh` copia:**

| Copied / Copiado | Not copied / Não copiado |
|------------------|--------------------------|
| `.claude/` (entire structure / estrutura completa) | Template `README.md` |
| `CLAUDE.md` (if doesn't exist / se não existir) | `QUICKSTART.md` |
| `.gitignore` (if doesn't exist / se não existir) | `docs/` folder / pasta |

`/project-adopt` is different from `/project-init` — it uses the `researcher` agent to discover the existing stack and conventions before asking any questions. / `/project-adopt` é diferente do `/project-init` — usa o agent `researcher` para descobrir a stack e convenções existentes antes de fazer qualquer pergunta.
