---
name: deploy
description: Pre-deploy checklist and procedure. Run before any deploy in any environment. Validates code, environment, migrations and team communication.
disable-model-invocation: true
---

# Skill: deploy

**When to use:** Before any deploy in any environment.

> This file is a template. Fill the configuration section during or after `/project-init`.
> See `scripts/` directory for automation scripts you can add.

---

## Project configuration

<!-- Fill with real project data -->
- **Staging:** [URL]
- **Production:** [URL]
- **Deploy command:** [command]
- **Environment variables:** [list or reference to .env.example]
- **Migrations:** [yes/no — if yes, which command]
- **Rollback:** [procedure in case of failure]

---

## Pre-deploy checklist

### Code
- [ ] Branch updated with main
- [ ] All tests passing locally
- [ ] No debug variables active
- [ ] Migrations reviewed and tested (if any)

### Security
- [ ] No hardcoded secrets
- [ ] Production environment variables verified

### Spec
- [ ] Feature spec updated to status `done`
- [ ] `INDEX.md` updated
- [ ] Anything to record in `lessons.md`?

### Communication
- [ ] Team notified (if there is a team)
- [ ] Adequate deploy window — avoid peak hours and weekends

---

## After deploy

- Monitor logs for 15 minutes
- Manually confirm main functionalities
- Update the PR with the deploy date

## Supporting scripts

See [`scripts/`](scripts/) for optional automation scripts you can add to this skill.
