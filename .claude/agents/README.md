# Agents available / Agentes disponíveis

Invoke explicitly by name. Agents are isolated — they only have access to the tools defined in each one.
Invoque explicitamente pelo nome. Agentes são isolados — têm acesso apenas às ferramentas definidas em cada um.

| Agent / Agente | File / Arquivo | When to use / Quando usar |
|----------------|----------------|---------------------------|
| `code-reviewer` | `.claude/agents/code-reviewer.md` | Analyze code without modifying anything / Analisar código sem modificar nada |
| `researcher` | `.claude/agents/researcher.md` | Explore large repository, map structure / Explorar repositório grande, mapear estrutura |
| `planner` | `.claude/agents/planner.md` | Generate PRD, implementation plan, create specs / Gerar PRD, plano de implementação, criar specs |

## How to invoke / Como invocar

```
"use the code-reviewer agent to analyze the auth module"
"use o agente code-reviewer para analisar o módulo de auth"

"use the researcher agent to map how the payment system works"
"use o agente researcher para mapear como o sistema de pagamentos funciona"

"use the planner agent to create a spec for the reports feature"
"use o agente planner para criar uma spec da feature de relatórios"
```
