---
name: bugfix
description: Systematic bug triage protocol. Use when receiving a bug report or unexpected behavior. Follows reproduce→locate→reduce→fix→guard→verify sequence.
disable-model-invocation: true
argument-hint: "[bug description]"
---

# Skill: bugfix

**When to use:** When receiving a bug report or unexpected behavior. Replaces improvisation with a systematic process that avoids fixing symptoms instead of root causes.

---

## Triage — execute in this order, without skipping steps

### 1. Reproduce
Confirm you can reproduce the bug reliably before touching any code.
- What is the input or sequence of actions that triggers the problem?
- Is the bug deterministic or intermittent?
- If intermittent: what is the occurrence rate?

### 2. Locate
Identify the layer where the failure occurs:
- UI / frontend?
- Business logic / API?
- Database / query?
- External integration / network?
- Build / tooling / environment?

### 3. Reduce
Isolate the minimum case that still reproduces the problem.
- What is the smallest input that fails?
- What is the smallest piece of code involved?
- Does the problem exist in a clean environment (no previous state data)?

### 4. Fix
Fix the **root cause**, not the symptom.
- If the fix needs more than 20 lines, question whether you're attacking the right cause
- Don't refactor adjacent code together with the fix — separate scope, separate commit
- If you find other bugs along the way: record as issue/TODO, don't fix now

### 5. Guard (regression coverage)
Add the smallest test that would have failed before the fix and passes now.
- Unit tests for pure logic
- Integration tests for boundaries (DB, network, I/O)
- The test must be in the same commit as the fix

### 6. Verify
Confirm end-to-end for the original report:
- Is the expected behavior correct?
- Do existing tests still pass?
- Does the fix not introduce regression?

---

## Stop-the-line

If at any step something unexpected happens:
1. **Stop** — don't keep adding code
2. **Preserve** — save logs, stack trace, current state
3. **Re-plan** — return to step 1 with the new information

---

## Fix documentation template

Fill when done — record in the spec or directly in `lessons.md`:

```
**Bug:** [description in 1 sentence]
**Repro:** [minimum steps to reproduce]
**Expected vs actual:** [expected behavior] / [observed behavior]
**Root cause:** [what was actually wrong]
**Fix:** [what was changed — file:line]
**Regression coverage:** [name of test added]
**Verification:** [command run + result]
**Risk/rollback:** [low|medium|high — how to revert if necessary]
```

---

## After the fix

- If the bug revealed a knowledge gap: add entry in `lessons.md`
- If the fix required an architectural decision: record in `decisions.md`
