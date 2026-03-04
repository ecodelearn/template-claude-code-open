#!/usr/bin/env bash
# adopt.sh — adds Claude Code structure to an existing project
#
# USAGE:
#   gh repo clone [OWNER]/template-claude-code-open /tmp/cc-template -- --depth=1 --quiet \
#     && bash /tmp/cc-template/adopt.sh; rm -rf /tmp/cc-template
#
#   or, with the repo already cloned locally:
#   bash /path/to/template-claude-code-open/adopt.sh

set -euo pipefail

TEMPLATE_REPO="[OWNER]/template-claude-code-open"
TEMP_DIR=$(mktemp -d)
TARGET_DIR="${PWD}"

# --- Colors ---
info()  { echo -e "\033[34m[INFO]\033[0m $*"; }
ok()    { echo -e "\033[32m[ OK ]\033[0m $*"; }
warn()  { echo -e "\033[33m[WARN]\033[0m $*"; }
erro()  { echo -e "\033[31m[ERROR]\033[0m $*" >&2; exit 1; }

# --- Validations ---
[[ ! -d "${TARGET_DIR}/.git" ]] && erro "Run this script at the root of a git repository."
command -v gh &>/dev/null || erro "GitHub CLI (gh) not found. Install at: https://cli.github.com"

info "Project detected: ${TARGET_DIR}"
info "Downloading template structure..."

gh repo clone "$TEMPLATE_REPO" "$TEMP_DIR" -- --depth=1 --quiet 2>/dev/null \
  || erro "Failed to clone template. Check access to: ${TEMPLATE_REPO}"

# --- Files to copy ---
# Only copies .claude/ structure and CLAUDE.md
# Does NOT overwrite: README.md, docs/, QUICKSTART.md

if [[ -d "${TARGET_DIR}/.claude" ]]; then
    warn ".claude/ already exists in this project."
    read -rp "Overwrite? Existing files will be lost. [y/N] " resposta
    [[ "${resposta,,}" != "y" ]] && { info "Operation cancelled."; rm -rf "$TEMP_DIR"; exit 0; }
fi

cp -r "${TEMP_DIR}/.claude" "${TARGET_DIR}/"
ok ".claude/ copied"

if [[ -f "${TARGET_DIR}/CLAUDE.md" ]]; then
    warn "CLAUDE.md already exists — keeping existing."
else
    cp "${TEMP_DIR}/CLAUDE.md" "${TARGET_DIR}/"
    ok "CLAUDE.md copied"
fi

# Copy .gitignore only if it doesn't exist
if [[ ! -f "${TARGET_DIR}/.gitignore" ]]; then
    cp "${TEMP_DIR}/.gitignore" "${TARGET_DIR}/"
    ok ".gitignore copied"
fi

rm -rf "$TEMP_DIR"

# --- Hook permissions ---
chmod +x "${TARGET_DIR}/.claude/hooks/"*.sh 2>/dev/null || true

# --- Result ---
echo ""
ok "Claude Code structure added to project."
echo ""
echo "  What was added:"
echo "  .claude/skills/       ← 7 skills (project-init, spec-create, bugfix, ...)"
echo "  .claude/agents/       ← 3 agents (code-reviewer, researcher, planner)"
echo "  .claude/rules/        ← path-scoped rules (customize for your stack)"
echo "  .claude/hooks/        ← block-destructive + auto-format + session-end"
echo "  .claude/agent-memory/ ← shared agent memory (committed to git)"
echo "  .claude/memory/       ← project context files"
echo ""
echo "  Next step:"
echo "  1. Open Claude Code at project root: claude"
echo "  2. Run: /project-adopt"
echo ""
echo "  Claude will map the existing codebase and configure memory"
echo "  with the conventions and stack already in the code."
echo ""
