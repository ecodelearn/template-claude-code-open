---
name: pr-review
description: Checklist for opening or reviewing a pull request. Validates code quality, spec completion, tests, and security before any PR is opened or approved.
disable-model-invocation: true
---

# Skill: pr-review

**When to use:** Before opening a PR or when reviewing someone else's PR.

---

## Checklist — opening a PR

### Code
- [ ] Simplest possible solution for the problem?
- [ ] No error from `lessons.md` repeated?
- [ ] No dead code, debug logs, or temporary comments
- [ ] Self-explanatory names — no obscure abbreviations

### Spec
- [ ] All spec tasks marked as completed?
- [ ] Spec updated with status `review`?
- [ ] `INDEX.md` updated?

### Tests
- [ ] Happy path and error cases covered?
- [ ] No test commented out or skipped without justification?

### Security
- [ ] No hardcoded credential or secret?
- [ ] User inputs validated at system boundaries?

### The PR itself
- [ ] Title in format `type(scope): description` — e.g.: `feat(auth): add JWT refresh`
- [ ] Description: WHAT changed + WHY (not how)
- [ ] Atomic PR — one logical change per PR

---

## Checklist — reviewing someone else's PR

- [ ] Is the objective of the change clear?
- [ ] Approach consistent with `decisions.md`?
- [ ] Conflicts with anything in `lessons.md`?
- [ ] Would the code be understandable in 6 months?
- [ ] Anything learned in this review worth adding to `lessons.md`?

---

## After approval

Move the corresponding spec to status `done` and update the `INDEX.md` with the date and PR link.
