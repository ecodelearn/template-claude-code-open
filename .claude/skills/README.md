# Skills available / Skills disponíveis

Mention the skill name in the conversation to activate it. Skills are loaded on demand — they don't consume tokens until invoked.
Mencione o nome da skill na conversa para ativá-la. Skills são carregadas sob demanda — não consomem tokens até serem invocadas.

| Skill | File / Arquivo | When to use / Quando usar |
|-------|----------------|---------------------------|
| `project-init` | `.claude/skills/project-init.md` | First session — new blank project / Primeira sessão — projeto novo em branco |
| `project-adopt` | `.claude/skills/project-adopt.md` | Existing project receiving the structure for the first time / Projeto existente recebendo a estrutura pela primeira vez |
| `spec-create` | `.claude/skills/spec-create.md` | Start a new feature or phase / Iniciar nova feature ou fase |
| `bugfix` | `.claude/skills/bugfix.md` | Bug report — systematic triage until verified fix / Report de bug — triage sistemático até fix verificado |
| `pr-review` | `.claude/skills/pr-review.md` | Before opening or reviewing a PR / Antes de abrir ou revisar um PR |
| `commit` | `.claude/skills/commit.md` | Format commit message / Formatar mensagem de commit |
| `deploy` | `.claude/skills/deploy.md` | Before any deploy / Antes de qualquer deploy |

## How to invoke / Como invocar

```
"execute project-init"
"use skill spec-create for the authentication feature"
"use a skill spec-create para a feature de autenticação"
"follow the pr-review checklist"
"siga o checklist de pr-review"
"what is the commit format for this change?"
"qual o formato de commit para esta mudança?"
```
