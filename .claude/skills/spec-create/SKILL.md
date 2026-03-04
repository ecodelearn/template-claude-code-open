---
name: spec-create
description: Creates a formal spec for a new feature or phase. Use when starting any non-trivial implementation work.
disable-model-invocation: true
argument-hint: "[feature-name]"
---

# Skill: spec-create

**When to use:** When starting a new feature, phase, or sprint. Can be invoked directly or after the `planner` agent generates an approved PRD.

---

## Protocol

### If invoked without a ready PRD

Collect the minimum information before creating:

1. "What is the name and objective of this feature?" (1 clear sentence)
2. "What is out of scope?"
3. "Does it depend on any other spec to start?"
4. "What is the priority? (high / medium / low)"

### If invoked after a planner PRD

Use the content of the approved PRD directly — don't ask what has already been answered.

---

## Actions

1. **Generate the feature slug** from the name
   - Format: `[type]-[name]` in lowercase with hyphens
   - Examples: `feature-auth`, `fix-payment-race`, `refactor-orders-module`

2. **Fill the full slug** in the format `[project-slug]::[feature-slug]`
   - Read the `project` from the front matter of `.claude/memory/MEMORY.md`

3. **Create `.claude/specs/[feature-slug].md`**
   - Use the template `.claude/specs/_template.md` as base
   - Fill all fields with the collected information
   - Leave "How to resume" with a clear first step

4. **Update `.claude/specs/INDEX.md`**
   - Add to the "Backlog" section with slug, priority, and dependencies

5. **Confirm** the created/updated files to the user

---

## Expected result

A new spec in backlog, with enough context for any session or team member to start the work without needing additional briefing.
