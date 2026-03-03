# Spec: github-setup

**Status:** `in-progress`
**Slug:** `template-claude-code-open::github-setup`
**Sprint:** 1
**Created / Criado em:** 2026-03-03
**Last updated / Última atualização:** 2026-03-03

---

## Objective / Objetivo

Publish the repository on GitHub as a public template repository, ready for community use.

## Technical context / Contexto técnico

The template structure is already created locally. We need to publish it publicly and configure it as a GitHub template so users can create new repos from it with a single click.

## Out of scope / Fora do escopo

- GitHub Actions / CI pipelines (not needed for a template)
- Automated testing of the template itself
- Website or landing page

## Technical decisions / Decisões técnicas

- MIT License — most permissive, standard for open-source templates
- adopt.sh references this public repo (no private auth required)

## Dependencies / Dependências

- **Depends on / Depende de:** none
- **Blocks / Bloqueia:** nothing

## Relevant files / Arquivos relevantes

- `adopt.sh` — needs final repo URL updated
- `README.md` — bilingual user-facing docs
- `QUICKSTART.md` — bilingual quickstart guide
- `LICENSE` — to be created

## Acceptance criteria / Critérios de aceite

- [ ] Repository is public on GitHub
- [ ] Repo is marked as "Template repository" in GitHub Settings
- [ ] `adopt.sh` references the correct public repo URL
- [ ] MIT LICENSE file exists in root
- [ ] `gh repo create meu-projeto --template [OWNER]/template-claude-code-open --clone` works end to end
- [ ] README renders correctly on GitHub

## Tasks / Tarefas

- [ ] Update `adopt.sh` with final public repo reference (`[OWNER]/template-claude-code-open`)
- [ ] Create `LICENSE` file (MIT)
- [ ] Final review: grep for any remaining private repo references (`ecodelearn/template-claude-code` that aren't the open version)
- [ ] Create GitHub repo: `gh repo create template-claude-code-open --public --description "..."`
- [ ] Push: `git add -A && git commit -m "feat: initial open-source template" && git push -u origin main`
- [ ] Enable template flag: GitHub Settings → check "Template repository"
- [ ] Test end-to-end: create a test project from the template

---

## How to resume / Como retomar este trabalho

**Current state / Estado atual:** All template files created and adapted. Structure is complete.
**Next step / Próximo passo:** Update `adopt.sh` repo URL → create LICENSE → push to GitHub → enable template flag
**Blockers / Bloqueadores:** Need to decide on GitHub username/org for the public repo

---

## Verification / Verificação

<!-- Fill when done / Preencha ao concluir -->

## Implementation notes / Notas de implementação

- The adopt.sh currently has a `[OWNER]` placeholder — replace with actual GitHub username before pushing
- After enabling template flag, test with: `gh repo create test-from-template --template [OWNER]/template-claude-code-open --clone`
