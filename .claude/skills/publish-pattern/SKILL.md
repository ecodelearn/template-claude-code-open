---
name: publish-pattern
description: Publica padrões reutilizáveis no global-index do claude-memories. Use quando uma solução se provar genuinamente reutilizável em outros projetos.
disable-model-invocation: true
---

# Skill: publish-pattern

**Quando usar:** Quando uma solução se provar genuinamente reutilizável em outros projetos. Use com critério — só o que realmente economizaria tempo ou evitaria erros em um contexto diferente.

---

## Critérios para publicar

Publique se a solução:
- Resolveu um problema não óbvio
- É independente do contexto específico deste projeto
- Economizaria tempo ou evitaria erros em outro projeto

Não publique:
- Soluções muito específicas do domínio do negócio
- Workarounds temporários
- O que já está no global-index

---

## Formato da entrada

```markdown
### [Nome do Padrão] — [data]
**Origem:** `[project-slug]`
**Problema:** [o que resolvia — 1 frase]
**Solução:** [a abordagem — 2-3 frases]
**Por que funciona:** [raciocínio curto]
**Reutilizável quando:** [condições ou contexto]
**Detalhes:** [link para o arquivo no repo de origem]
```

---

## Configuração

```
claude-memories path:   ~/.claude/claude-memories/
claude-memories remote: https://github.com/ecodelearn/claude-memories
global-index file:      ~/.claude/claude-memories/global-index.md
```

---

## Protocolo de execução

### Passo 0 — Verificar e preparar o repositório claude-memories

Antes de qualquer edição, verificar se `~/.claude/claude-memories/` existe e é um repo git.

**Se o diretório não existir ou não for um repo git:**
```bash
# Clonar o repositório
git clone https://github.com/ecodelearn/claude-memories ~/.claude/claude-memories/
```

**Se o diretório existir mas não for git (pasta avulsa):**
```bash
cd ~/.claude/claude-memories
git init
git remote add origin https://github.com/ecodelearn/claude-memories
git fetch origin
git checkout -b main origin/main
```

**Se já for um repo git** (caso normal), apenas sincronizar:
```bash
cd ~/.claude/claude-memories && git pull origin main
```

### Passo 1 — Ler o contexto do projeto atual

Leia `.claude/memory/MEMORY.md` para confirmar o `project-slug`.

### Passo 2 — Editar global-index.md

Abra `~/.claude/claude-memories/global-index.md`.

Adicione a entrada na seção de categoria correspondente. Se a categoria não existir, crie com `### [Categoria]`.

Atualize a data de "Última atualização" no topo do arquivo.

### Passo 3 — Commit e push

```bash
cd ~/.claude/claude-memories
git add global-index.md
git commit -m "docs(global-index): add [nome] from [project-slug]"
git push origin main
```

### Passo 4 — Registrar no projeto atual

Adicione também uma nota em `.claude/memory/patterns.md` do projeto atual (ou crie o arquivo se não existir), com referência ao padrão publicado.

---

## Exemplo de entrada publicada

```markdown
### Cursor Pagination em tabelas grandes — 2026-03-04
**Origem:** `minha-api`
**Problema:** Offset pagination causava degradação de performance com >50k registros
**Solução:** Cursor baseado em `(created_at, id)` com índice composto — evita full scan
**Por que funciona:** O banco filtra a partir de um ponto fixo em vez de pular N linhas
**Reutilizável quando:** Qualquer endpoint com paginação em tabela de alto volume
**Detalhes:** ecodelearn/minha-api → .claude/memory/lessons.md#cursor-pagination
```

---

## Erros comuns

| Erro | Causa | Fix |
|------|-------|-----|
| `not a git repository` | Pasta existe mas não foi inicializada com git | Executar Passo 0 — branch git init |
| `Permission denied` | SSH não configurado para GitHub | Usar HTTPS (já configurado acima) |
| `rejected — non-fast-forward` | Repo remoto tem commits não puxados | `git pull --rebase origin main` antes do push |
| `global-index.md not found` | Repo clonado mas arquivo não existe | Criar o arquivo com o template básico |
