# Contributing / Como contribuir

[English](#english) · [Português do Brasil](#português-do-brasil)

## English

Thank you for helping improve this template.

### Before opening work

1. Search existing issues and pull requests.
2. Discuss large changes (new skills, agents, structure) in an issue first.
3. Never include credentials, private memory, customer data, or local settings
   (`.claude/settings.local.json`).
4. Keep the template universal: do not reference personal repositories, paths
   or machines.

### Development

```bash
git clone https://github.com/ecodelearn/template-claude-code-open.git
cd template-claude-code-open
```

Create a focused branch and check before pushing:

```bash
shellcheck adopt.sh .claude/hooks/*.sh
git diff --check
```

Public docs are bilingual (EN / PT-BR). When you change user-facing behavior,
update both languages, `CHANGELOG.md`, and `adopt.sh` / `adopt.ps1` together if
the list of copied files changes.

Pull requests should explain what changed, why, user impact, and how it was
verified. Maintainers may request changes before merging.

## Português do Brasil

Obrigado por ajudar a melhorar este template.

### Antes de iniciar

1. Pesquise issues e pull requests existentes.
2. Discuta mudanças grandes (novas skills, agentes, estrutura) em uma issue antes.
3. Nunca inclua credenciais, memória privada, dados de clientes ou configuração
   local (`.claude/settings.local.json`).
4. Mantenha o template universal: não referencie repositórios, caminhos ou
   máquinas pessoais.

### Desenvolvimento

```bash
git clone https://github.com/ecodelearn/template-claude-code-open.git
cd template-claude-code-open
```

Crie uma branch focada e verifique antes do push:

```bash
shellcheck adopt.sh .claude/hooks/*.sh
git diff --check
```

A documentação pública é bilíngue (EN / PT-BR). Ao mudar comportamento visível
ao usuário, atualize os dois idiomas, o `CHANGELOG.md` e, se a lista de arquivos
copiados mudar, `adopt.sh` e `adopt.ps1` juntos.

O PR deve explicar a mudança, o motivo, o impacto ao usuário e como foi
verificado. Maintainers podem solicitar ajustes antes do merge.
