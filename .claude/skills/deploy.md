# Skill: deploy

**When to use / Quando usar:** Before any deploy in any environment.

> This file is a template. Fill the configuration section during or after `project-init`.
> Este arquivo é um template. Preencha a seção de configuração durante ou após o `project-init`.

---

## Project configuration / Configuração deste projeto

<!-- Fill with real project data / Preencher com os dados reais do projeto -->
- **Staging:** [URL]
- **Production / Produção:** [URL]
- **Deploy command / Comando de deploy:** [command]
- **Environment variables / Variáveis de ambiente:** [list or reference to .env.example]
- **Migrations:** [yes/no — if yes, which command]
- **Rollback:** [procedure in case of failure / procedimento em caso de falha]

---

## Pre-deploy checklist / Checklist pré-deploy

### Code / Código
- [ ] Branch updated with main
- [ ] All tests passing locally
- [ ] No debug variables active
- [ ] Migrations reviewed and tested (if any)

### Security / Segurança
- [ ] No hardcoded secrets
- [ ] Production environment variables verified

### Spec
- [ ] Feature spec updated to status `done`
- [ ] `INDEX.md` updated
- [ ] Anything to record in `lessons.md`?

### Communication / Comunicação
- [ ] Team notified (if there is a team)
- [ ] Adequate deploy window — avoid peak hours and weekends

---

## After deploy / Após o deploy

- Monitor logs for 15 minutes
- Manually confirm main functionalities
- Update the PR with the deploy date
