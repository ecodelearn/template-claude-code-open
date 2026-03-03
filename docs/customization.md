# Customization — adapting the template to your project / Customização — adaptando o template ao seu projeto

## Adding a skill / Adicionando uma skill

Create a file `.claude/skills/my-skill.md`:

```markdown
# Skill: my-skill

**When to use / Quando usar:** [describe the situation that should trigger this skill]

## What to do / O que fazer

[Step-by-step instructions of what Claude should execute]

## Expected output format / Formato de saída esperado

[If there is a specific format, show an example]
```

Add a line to the table in `.claude/skills/README.md`:

```markdown
| `my-skill` | `my-skill.md` | [when to use — 1 sentence] |
```

**Best practices for skills / Boas práticas para skills:**
- The "When to use" description should be specific — Claude needs to know exactly when to trigger it
- Include practical examples in the file — skills are loaded on demand, so examples don't cost tokens day-to-day
- One skill per responsibility — don't create skills that do too many things

---

## Adding an agent / Adicionando um agente

Create `.claude/agents/my-agent.md` with the required front matter:

```markdown
---
name: my-agent
description: [What this agent does and when it should be used — Claude uses this to decide when to invoke it]
tools: Read, Glob, Grep
---

# Agent: my-agent

[Agent instructions]
```

**Available tools for agents / Ferramentas disponíveis para agentes:**
- `Read, Glob, Grep` — read-only (ideal for reviewers and researchers)
- `Read, Glob, Grep, Bash` — read + execution (without modifying files)
- `Read, Glob, Grep, Write, Edit` — can modify files
- `Read, Glob, Grep, Write, Edit, Bash` — full access

Add a line to `.claude/agents/README.md`.

**General rule / Regra geral:** give the agent only the tools it really needs. Less access = less risk of unexpected side effects.

---

## Modifying hooks / Modificando os hooks

### Add a blocked pattern to block-destructive.sh / Adicionar um padrão bloqueado

```bash
# In .claude/hooks/block-destructive.sh, add to the BLOCKED array:
BLOCKED=(
    # ... existing patterns ...
    "my-dangerous-pattern"
)
```

### Add support for a new formatter in auto-format.sh / Adicionar suporte a um novo formatador

```bash
# In .claude/hooks/auto-format.sh, add a case:
case "$EXT" in
    # ... existing cases ...
    lua)
        command -v stylua &>/dev/null && stylua "$FILE" 2>/dev/null
        ;;
esac
```

### Create a new hook / Criar um hook novo

1. Create the script in `.claude/hooks/my-hook.sh`
2. Make it executable: `chmod +x .claude/hooks/my-hook.sh`
3. Register in `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/my-hook.sh"
          }
        ]
      }
    ]
  }
}
```

**Available events / Eventos disponíveis:** `PreToolUse`, `PostToolUse`, `Notification`, `Stop`, `SubagentStop`

The hook receives JSON via stdin with `tool_name` and `tool_input`. Exit code 2 blocks the action with the stdout message as explanation.

---

## Adding lib references as the project evolves / Adicionando referências de libs ao longo do projeto

When adding a new lib or framework to the project, add its documentation in `.claude/references.md`:

```markdown
## This Project / Deste Projeto

| Resource | URL | When to use |
|----------|-----|-------------|
| Fastify docs | https://fastify.dev/docs/latest/ | Routes, plugins, lifecycle |
| Prisma docs | https://www.prisma.io/docs | Schema, migrations, queries |
| My new lib | https://docs.mynewlib.com | [when to consult] |
```

---

## Customizing CLAUDE.md / Personalizando o CLAUDE.md

The `CLAUDE.md` has sections filled by `project-init`, but you can edit manually at any time:

- **Session protocol:** add project-specific steps if needed
- **Non-negotiable principles:** add rules discovered along the project

**Don't add to CLAUDE.md / Não adicione ao CLAUDE.md:**
- Detailed technical documentation → goes in `memory/MEMORY.md`
- Skill instructions → goes in `.claude/skills/`
- Decision history → goes in `memory/decisions.md`

CLAUDE.md must remain small. It is read in every session.

---

## Adopting the template in an existing project / Adotando o template em um projeto existente

If the project already has code and you want to add this structure:

```bash
# At the root of the existing project / Na raiz do projeto existente
gh repo clone [OWNER]/template-claude-code-open /tmp/cc-template -- --depth=1 --quiet && bash /tmp/cc-template/adopt.sh; rm -rf /tmp/cc-template
```

The script copies `.claude/` and `CLAUDE.md` without touching any existing project files.

Then open Claude Code and run `project-adopt`. Unlike `project-init` (which defines conventions from scratch), `project-adopt`:
1. Uses the `researcher` agent to read `package.json`, lint configs, git log, directory structure
2. Arrives at the interview with the obvious answers already — you confirm, not answer from scratch
3. Creates specs for features already in progress
4. Respects existing conventions instead of redefining them

**What `adopt.sh` copies and what it doesn't / O que o `adopt.sh` copia e o que não copia:**

| Copied / Copiado | Not copied / Não copiado |
|------------------|--------------------------|
| `.claude/` entire | Template `README.md` |
| `CLAUDE.md` (if it doesn't exist) | `QUICKSTART.md` |
| `.gitignore` (if it doesn't exist) | `docs/` folder |

---

## Creating specs manually / Criando specs manualmente

If you prefer to create specs without the `spec-create` skill:

1. Copy `.claude/specs/_template.md` to `.claude/specs/[feature-slug].md`
2. Fill all fields (remove HTML comments)
3. Fill **Acceptance criteria** before starting to implement
4. Add to `INDEX.md` in the "Backlog" section
5. Commit: `git add .claude/specs/ && git commit -m "docs(specs): add [feature-slug] spec"`
