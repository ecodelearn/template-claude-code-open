# Team workflow / Fluxo em times

## Setup for a new team member / Configuração para um novo membro

### Project already using this template (MEMORY.md filled) / Projeto já usando o template (MEMORY.md preenchido)

```bash
git clone git@github.com:[owner]/[project].git
cd [project]
claude
```

Claude reads `MEMORY.md` and `specs/INDEX.md` automatically — the new member has full context immediately. / Claude lê `MEMORY.md` e `specs/INDEX.md` automaticamente — o novo membro tem contexto completo imediatamente. Check `README_MCP.md` in the root to configure the necessary local integrations. / Verifique `README_MCP.md` na raiz para configurar as integrações locais necessárias.

### Existing project not yet using the template / Projeto existente ainda sem o template

```bash
git clone git@github.com:[owner]/[project].git
cd [project]

# Add the Claude Code structure / Adicionar a estrutura Claude Code
gh repo clone [OWNER]/template-claude-code-open /tmp/cc-template -- --depth=1 --quiet \
  && bash /tmp/cc-template/adopt.sh; rm -rf /tmp/cc-template

claude
# Run / Execute: /project-adopt
```

`/project-adopt` uses the `researcher` agent to map the stack, conventions and in-progress work automatically before asking any questions. / `/project-adopt` usa o agente `researcher` para mapear a stack, convenções e trabalho em andamento automaticamente antes de fazer qualquer pergunta. The result is a `MEMORY.md` populated from the code — not answered in a form. / O resultado é um `MEMORY.md` populado a partir do código — sem perguntas de formulário.

---

## What is shared vs. local / O que é compartilhado vs. local

Understanding what lives where prevents confusion in team environments. / Entender o que fica onde evita confusão em ambientes de time.

| What / O quê | Location / Local | Shared via git? / Via git? | Notes / Notas |
|--------------|------------------|---------------------------|---------------|
| Project context / Contexto do projeto | `.claude/memory/` | Yes / Sim | Commit when it changes / Commite ao mudar |
| Feature specs / Specs de features | `.claude/specs/` | Yes / Sim | Commit with or separately from code / Com o código ou separado |
| Skills | `.claude/skills/` | Yes / Sim | Part of the project structure / Parte da estrutura |
| Agents | `.claude/agents/` | Yes / Sim | Part of the project structure / Parte da estrutura |
| Rules / Regras | `.claude/rules/` | Yes / Sim | Part of the project structure / Parte da estrutura |
| Agent memory (project) / Memória de agent (projeto) | `.claude/agent-memory/` | Yes / Sim | Accumulated knowledge, commit regularly / Conhecimento acumulado |
| Hooks | `.claude/hooks/` | Yes / Sim | Shared guardrails / Guardrails compartilhados |
| Team hook config / Config de hooks do time | `.claude/settings.json` | Yes / Sim | Hook definitions for everyone / Definições para todos |
| Personal hook config / Config pessoal de hooks | `.claude/settings.local.json` | No — gitignored | Each person's personal settings / Configurações pessoais |
| MCP config | `README_MCP.md` | No — gitignored | Each person runs commands locally / Cada pessoa roda localmente |
| Claude auto-memory / Auto-memória do Claude | `~/.claude/projects/<repo>/` | No | Machine-local, never committed / Local da máquina, nunca commitado |
| Local agent memory / Memória local de agent | `.claude/agent-memory-local/` | No — gitignored | Personal agent notes / Notas pessoais de agent |
| Personal preferences / Preferências pessoais | `CLAUDE.local.md` | No — gitignored | Individual overrides / Overrides individuais |

---

## Daily sync / Sincronização diária

Memory, specs and agent memory are versioned files — no extra infrastructure needed. / Memória, specs e memória de agents são arquivos versionados — sem infraestrutura extra necessária.

```bash
# Start of any session — get the latest team context / Início de sessão — obter contexto atualizado do time
git pull

# Claude automatically reads MEMORY.md and specs/INDEX.md on open
# Claude lê automaticamente MEMORY.md e specs/INDEX.md ao abrir

# End of session — commit accumulated context / Fim de sessão — commitar contexto acumulado
git add .claude/memory/ .claude/specs/ .claude/agent-memory/
git commit -m "chore(context): update memory/specs"
git push
```

### Optional: auto-commit at session end / Opcional: auto-commit ao fim da sessão

To enable automatic context commits when Claude Code closes: / Para habilitar commits automáticos de contexto quando o Claude Code fecha:

```bash
cp .claude/settings.local.json.example .claude/settings.local.json
```

The `SessionEnd` hook will commit `.claude/memory/` and `.claude/specs/` automatically. / O hook `SessionEnd` commitará `.claude/memory/` e `.claude/specs/` automaticamente. This file is gitignored — each team member opts in individually. / Este arquivo é gitignored — cada membro do time opta individualmente.

---

## Working on parallel features / Trabalhando em features paralelas

Two developers can work on different features simultaneously without conflict — each feature has its own spec file. / Dois desenvolvedores podem trabalhar em features diferentes simultaneamente sem conflito — cada feature tem seu próprio arquivo de spec.

```
Dev A  →  .claude/specs/feature-auth.md
Dev B  →  .claude/specs/feature-orders.md
```

The only shared file that can have conflicts is `specs/INDEX.md`. / O único arquivo compartilhado que pode ter conflitos é `specs/INDEX.md`. Resolution is simple: in a merge conflict, keep the rows from both sides. / A resolução é simples: em um conflito de merge, mantenha as linhas dos dois lados.

**Recommended strategy / Estratégia recomendada:**

```bash
# When starting a feature, create the branch and spec together
# Ao iniciar uma feature, crie o branch e a spec juntos
git checkout -b feat/auth
# /spec-create user-authentication
git add .claude/specs/feature-auth.md .claude/specs/INDEX.md
git commit -m "docs(specs): add feature-auth spec"
git push -u origin feat/auth
```

The spec stays on the feature branch — it enters main together with the code on PR merge. / A spec fica no branch da feature — entra na main junto com o código no merge do PR.

---

## Handoff between sessions / Handoff entre sessões

The "How to resume" field in the spec is the handoff protocol. / O campo "How to resume" na spec é o protocolo de handoff. Fill it whenever pausing work. / Preencha sempre que pausar o trabalho.

```markdown
## How to resume this work / Como retomar este trabalho

**Current state / Estado atual:** POST /auth/login endpoint implemented and tested
**Next step / Próximo passo:** create POST /auth/refresh in src/auth/refresh.ts — schema already in src/db/schema.ts:45
**Blockers / Bloqueios:** none / nenhum
```

When another developer (or another session) picks up the feature: / Quando outro desenvolvedor (ou outra sessão) assume a feature:
1. `git pull`
2. Claude reads `INDEX.md` → identifies the in-progress feature / identifica a feature em andamento
3. Claude reads `feature-auth.md` → "How to resume" → continues exactly where it stopped / continua exatamente de onde parou

**No verbal briefing needed. / Sem briefing verbal necessário.**

---

## Shared agent knowledge / Conhecimento compartilhado de agents

Agents with `memory: project` (currently the `researcher` agent) write knowledge to `.claude/agent-memory/<agent>/`. / Agents com `memory: project` (atualmente o agente `researcher`) escrevem conhecimento em `.claude/agent-memory/<agent>/`. This directory is committed to git. / Este diretório é commitado no git.

**Practical effect for new team members / Efeito prático para novos membros:**

```
New team member clones the project / Novo membro clona o projeto
  → gets the code / recebe o código
  → gets MEMORY.md (project context / contexto do projeto)
  → gets specs (current work state / estado atual do trabalho)
  → gets agent-memory/researcher/ (months of codebase exploration already done / meses de exploração do codebase já feitos)

First time they run the researcher agent / Primeira vez que rodam o agente researcher:
  → it reads its accumulated memory first / lê a memória acumulada primeiro
  → answers immediately with deep codebase knowledge / responde imediatamente com conhecimento profundo
  → no re-exploration from scratch needed / sem re-exploração do zero
```

Commit agent memory regularly alongside memory and specs: / Commite memória de agents regularmente junto com memória e specs:

```bash
git add .claude/memory/ .claude/specs/ .claude/agent-memory/
git commit -m "chore(context): update memory/specs/agent-knowledge"
```

---

## Conflicts in memory files / Conflitos em arquivos de memória

`lessons.md` and `decisions.md` grow by appending new entries. / `lessons.md` e `decisions.md` crescem com a adição de novas entradas. Merge conflicts are rare but when they happen: / Conflitos de merge são raros mas quando acontecem:

- **Rule / Regra:** keep both entries — never discard a lesson / mantenha as duas entradas — nunca descarte uma lição
- Each entry has a date, so it's easy to see which is more recent / Cada entrada tem data, então é fácil ver qual é mais recente
- In case of contradictory entries, add a note explaining the evolution / Em caso de entradas contraditórias, adicione uma nota explicando a evolução

---

## Bugs found during team work / Bugs encontrados durante o trabalho em time

```
/bugfix [description of wrong behavior / descrição do comportamento errado]
```

The skill guides: reproduce → locate → reduce → fix → regression coverage → verify. / A skill guia: reproduzir → localizar → reduzir → corrigir → cobertura de regressão → verificar. When done, the fix documentation is recorded in `lessons.md` — the whole team learns from it. / Quando concluído, a documentação do fix é registrada em `lessons.md` — todo o time aprende.

**Why this matters / Por que isso importa:** without documentation, the same bug can be debugged by two different members at different times. / sem documentação, o mesmo bug pode ser depurado por dois membros diferentes em momentos diferentes. With `lessons.md` updated, the second occurrence is recognized immediately. / Com `lessons.md` atualizado, a segunda ocorrência é reconhecida imediatamente.

---

## MCP integrations for the team / Integrações MCP para o time

After `/project-init`, a `README_MCP.md` file is created at the root with the necessary integrations. / Após `/project-init`, um arquivo `README_MCP.md` é criado na raiz com as integrações necessárias. Each team member must run the listed commands locally — MCP integrations live in `~/.claude/` on each machine (never committed), only documented. / Cada membro do time deve rodar os comandos listados localmente — integrações MCP vivem em `~/.claude/` em cada máquina (nunca commitadas), apenas documentadas.

Example of generated `README_MCP.md` / Exemplo de `README_MCP.md` gerado:

```markdown
# MCP Integrations — [PROJECT]

## GitHub
claude mcp add github -- npx -y @modelcontextprotocol/server-github
Requires: GITHUB_PERSONAL_ACCESS_TOKEN in environment

## PostgreSQL
claude mcp add postgres -- npx -y @modelcontextprotocol/server-postgres postgresql://localhost/[db]
Requires: local database configured / banco de dados local configurado
```

---

## PR workflow with specs / Fluxo de PR com specs

```bash
# 1. Before opening the PR / Antes de abrir o PR
/pr-review

# 2. Spec must be in status "review" and INDEX.md updated
# 2. Spec deve estar no status "review" e INDEX.md atualizado

# 3. After PR approval and merge / Após aprovação e merge do PR
# Move spec to "done" status and record the PR link in INDEX.md
# Mova a spec para status "done" e registre o link do PR no INDEX.md
```

The spec acts as the PR description source — everything reviewers need to understand the change is already written there. / A spec serve como fonte para a descrição do PR — tudo que os revisores precisam para entender a mudança já está escrito lá.

---

## Rules for the team / Regras para o time

The `.claude/rules/` directory is committed to git — everyone on the team benefits from path-scoped rules. / O diretório `.claude/rules/` é commitado no git — todos no time se beneficiam das regras por caminho. When adding rules for a new area of the codebase: / Ao adicionar regras para uma nova área do codebase:

1. Create `.claude/rules/[area].md` with `paths:` frontmatter / Crie com frontmatter `paths:`
2. Keep rules specific and actionable (not vague guidelines) / Mantenha as regras específicas e acionáveis (não diretrizes vagas)
3. Commit alongside the code changes that motivated the rule / Commite junto com as mudanças de código que motivaram a regra

```bash
git add .claude/rules/api.md
git commit -m "docs(rules): add API validation conventions"
```

Rules load automatically — no need to ask Claude to "follow the API rules." / Regras carregam automaticamente — sem necessidade de pedir a Claude para "seguir as regras de API." They are injected into context when Claude opens any matching file. / Elas são injetadas no contexto quando Claude abre qualquer arquivo correspondente.
