#!/usr/bin/env bash
# Hook: SessionEnd — auto-commits context files (memory + specs) at end of session
#
# ENABLE: Add to .claude/settings.local.json (personal, gitignored):
#
#   {
#     "hooks": {
#       "SessionEnd": [{
#         "hooks": [{
#           "type": "command",
#           "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/session-end-context.sh",
#           "statusMessage": "Saving session context..."
#         }]
#       }]
#     }
#   }

# Only run inside a git repo
git rev-parse --git-dir > /dev/null 2>&1 || exit 0

cd "$(git rev-parse --show-toplevel)" || exit 0

# Check if there are uncommitted changes in context directories
CONTEXT_CHANGED=$(git status --porcelain .claude/memory/ .claude/specs/ 2>/dev/null)
[[ -z "$CONTEXT_CHANGED" ]] && exit 0

git add .claude/memory/ .claude/specs/ 2>/dev/null || exit 0

# Nothing staged after add (e.g., all ignored)
git diff --cached --quiet && exit 0

git commit -m "chore(context): auto-update memory and specs [session-end]" 2>/dev/null
exit 0
