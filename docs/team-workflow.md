# Team workflow — using the template with multiple developers / Workflow em time

## Setup for a new team member / Setup para novo membro do time

There are two distinct scenarios / Há dois cenários distintos:

### Project already using the template (MEMORY.md filled) / Projeto que já usa o template

```bash
git clone git@github.com:[owner]/[project].git
cd [project]
claude
```

Claude reads `MEMORY.md` and `specs/INDEX.md` automatically — the new member has full context in seconds. Check `README_MCP.md` in the root to configure the necessary local integrations.

### Existing project not yet using the template / Projeto existente que ainda não usa o template

```bash
git clone git@github.com:[owner]/[project].git
cd [project]

# Add the Claude Code structure / Adicionar a estrutura Claude Code
gh repo clone [OWNER]/template-claude-code-open /tmp/cc-template -- --depth=1 --quiet && bash /tmp/cc-template/adopt.sh; rm -rf /tmp/cc-template

# Open Claude Code and map the project / Abrir o Claude Code e mapear o projeto
claude
# Run / Execute: "project-adopt"
```

`project-adopt` uses the `researcher` agent to automatically map stack, conventions and in-progress work before asking any questions. The result is a `MEMORY.md` filled with what was discovered in the code, not answered in a form.

---

## Daily sync / Sincronização diária

Memory and specs are files versioned together with the code. No extra infrastructure needed.
Memória e specs são arquivos versionados junto com o código. Nenhuma infraestrutura extra necessária.

```bash
# Start of any session — get the latest context from the team
# Início de qualquer sessão — pegar o contexto mais recente do time
git pull

# Claude automatically reads MEMORY.md and specs/INDEX.md on open

# During work / Durante o trabalho
# Claude updates specs and memory throughout the session

# When closing the session — commit accumulated context
# Ao fechar a sessão — commitar o contexto acumulado
git add .claude/memory/ .claude/specs/
git commit -m "chore(context): update memory/specs"
git push
```

---

## Working on parallel features / Trabalhando em features paralelas

Two developers can work on different features simultaneously without conflict, since each feature has its own spec file.

```
Dev A  →  .claude/specs/feature-auth.md
Dev B  →  .claude/specs/feature-orders.md
```

The only shared file that can have conflicts is `specs/INDEX.md`. Resolution is simple: in a merge conflict in INDEX.md, keep the lines from both sides.

**Recommended strategy for teams / Estratégia recomendada para times:**

```bash
# When starting a feature, create the branch and spec together
# Ao iniciar uma feature, crie a branch e a spec juntas
git checkout -b feat/auth
# "use skill spec-create for the authentication feature"
git add .claude/specs/feature-auth.md .claude/specs/INDEX.md
git commit -m "docs(specs): add feature-auth spec"
git push -u origin feat/auth
```

The spec stays on the feature branch — it enters main together with the code on the PR merge.

---

## Handoff between sessions / Passagem de bastão entre sessões

The "How to resume" field in the spec is the handoff protocol. **Must be filled whenever pausing work.**

```markdown
## How to resume this work

**Current state:** POST /auth/login endpoint implemented and tested
**Next step:** create POST /auth/refresh in src/auth/refresh.ts — schema is already in src/db/schema.ts:45
**Blockers:** none
```

When another developer (or another session) picks up the feature:
1. `git pull`
2. Claude reads `INDEX.md` → identifies the in-progress feature
3. Claude reads `feature-auth.md` → "How to resume" section → knows exactly where to continue

**No verbal briefing needed. / Nenhum briefing verbal necessário.**

---

## Conflicts in lessons.md and decisions.md / Conflitos em lessons.md e decisions.md

These files grow with new entries. Merge conflicts are rare, but when they happen:

- **Rule / Regra:** keep both entries — never discard a lesson
- Each entry has a date, so it's easy to identify which is more recent
- In case of contradictory entries, add a note explaining the evolution

---

## Bugs found during team work / Bugs encontrados durante o trabalho em time

When a team member finds a bug during development:

```
"use skill bugfix for [description of wrong behavior]"
```

The skill guides the process: reproduce → locate → reduce → fix → regression coverage → verify. When done, the fix documentation template is recorded in `lessons.md` — the whole team learns the error and how it was resolved.

**Why this matters in teams / Por que isso importa em times:** without documentation, the same bug can be found and debugged by two different members at different times. With `lessons.md` updated, the second occurrence is recognized immediately.

---

## MCP integrations for the team / Integrações MCP para o time

After `project-init`, a `README_MCP.md` file is created at the root with the necessary integrations. Each team member must run the listed commands locally — MCP integrations are not versioned (they live in `~/.claude/` on each machine), only documented.

Example of generated `README_MCP.md`:

```markdown
# MCP Integrations — [PROJECT]

## GitHub
claude mcp add github -- npx -y @modelcontextprotocol/server-github
Requires: GITHUB_PERSONAL_ACCESS_TOKEN in environment

## PostgreSQL
claude mcp add postgres -- npx -y @modelcontextprotocol/server-postgres postgresql://localhost/[db]
Requires: local database configured
```
