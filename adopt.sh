#!/usr/bin/env bash
# adopt.sh — adds Claude Code structure to an existing project
#
# USAGE:
#   gh repo clone ecodelearn/template-claude-code-open /tmp/cc-template -- --depth=1 --branch v1.0.0 --quiet \
#     && bash /tmp/cc-template/adopt.sh; rm -rf /tmp/cc-template
#
#   or, with the repo already cloned locally:
#   bash /path/to/template-claude-code-open/adopt.sh
#
# The script installs the copy it was run from (so what you reviewed is what you
# get). Only when run as a lone file does it clone the template; set TEMPLATE_REF
# to pin that clone to a tag or branch.
#
# WINDOWS:
#   If you're on Windows, use adopt.ps1 (PowerShell native) instead.
#   See: https://github.com/ecodelearn/template-claude-code-open

set -euo pipefail

TEMPLATE_REPO="ecodelearn/template-claude-code-open"
TEMPLATE_REF="${TEMPLATE_REF:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${PWD}"
TEMP_DIR=""
trap '[[ -n "$TEMP_DIR" ]] && rm -rf "$TEMP_DIR"' EXIT

# --- Colors ---
info()  { echo -e "\033[34m[INFO]\033[0m $*"; }
ok()    { echo -e "\033[32m[ OK ]\033[0m $*"; }
warn()  { echo -e "\033[33m[WARN]\033[0m $*"; }
erro()  { echo -e "\033[31m[ERROR]\033[0m $*" >&2; exit 1; }

# --- Validations ---
[[ ! -d "${TARGET_DIR}/.git" ]] && erro "Run this script at the root of a git repository."
[[ "$SCRIPT_DIR" == "$TARGET_DIR" ]] && erro "Run this from the project you want to adopt, not from the template itself."

info "Project detected: ${TARGET_DIR}"

# --- Source: the copy this script lives in, or a fresh clone ---
if [[ -d "${SCRIPT_DIR}/.claude" && -f "${SCRIPT_DIR}/CLAUDE.md" ]]; then
    SRC_DIR="$SCRIPT_DIR"
    info "Using template at: ${SRC_DIR}"
else
    command -v gh &>/dev/null || erro "GitHub CLI (gh) not found. Install at: https://cli.github.com"
    TEMP_DIR=$(mktemp -d)
    SRC_DIR="$TEMP_DIR"
    info "Downloading template structure${TEMPLATE_REF:+ (ref: ${TEMPLATE_REF})}..."
    if [[ -n "$TEMPLATE_REF" ]]; then
        gh repo clone "$TEMPLATE_REPO" "$TEMP_DIR" -- --depth=1 --branch "$TEMPLATE_REF" --quiet 2>/dev/null \
          || erro "Failed to clone ${TEMPLATE_REPO} at ref ${TEMPLATE_REF}."
    else
        warn "No TEMPLATE_REF set — cloning the default branch."
        gh repo clone "$TEMPLATE_REPO" "$TEMP_DIR" -- --depth=1 --quiet 2>/dev/null \
          || erro "Failed to clone template. Check access to: ${TEMPLATE_REPO}"
    fi
fi

info "Hooks that will be installed and run by Claude Code in this project:"
for h in "${SRC_DIR}/.claude/hooks/"*.sh; do echo "         - .claude/hooks/$(basename "$h")"; done

# --- Files to copy ---
# Only copies .claude/, CLAUDE.md and AGENTS.md
# Does NOT overwrite: README.md, docs/, QUICKSTART.md

if [[ -d "${TARGET_DIR}/.claude" ]]; then
    warn ".claude/ already exists in this project."
    info "Default: add only the files that are missing; existing files are kept."
    read -rp "Overwrite existing files instead? A backup is saved first. [y/N] " resposta
    if [[ "${resposta,,}" == "y" ]]; then
        BACKUP="${TARGET_DIR}/.claude.bak-$(date +%Y%m%d-%H%M%S)"
        cp -a "${TARGET_DIR}/.claude" "$BACKUP"
        ok "Backup saved: ${BACKUP}"
        cp -r "${SRC_DIR}/.claude" "${TARGET_DIR}/"
        ok ".claude/ overwritten"
    else
        # -n: never overwrite existing files
        cp -rn "${SRC_DIR}/.claude/." "${TARGET_DIR}/.claude/" || true   # newer coreutils exit 1 when skipping
        ok ".claude/ merged (existing files kept)"
        if ! cmp -s "${SRC_DIR}/.claude/settings.json" "${TARGET_DIR}/.claude/settings.json"; then
            cp "${SRC_DIR}/.claude/settings.json" "${TARGET_DIR}/.claude/settings.template.json"
            warn "Your .claude/settings.json differs from the template's."
            warn "Merge 'permissions.deny' and 'hooks' from .claude/settings.template.json by hand,"
            warn "then delete that file."
        fi
    fi
else
    cp -r "${SRC_DIR}/.claude" "${TARGET_DIR}/"
    ok ".claude/ copied"
fi

if [[ -f "${TARGET_DIR}/CLAUDE.md" ]]; then
    warn "CLAUDE.md already exists — keeping existing."
else
    cp "${SRC_DIR}/CLAUDE.md" "${TARGET_DIR}/"
    ok "CLAUDE.md copied"
fi

if [[ -f "${TARGET_DIR}/AGENTS.md" ]]; then
    warn "AGENTS.md already exists — keeping existing."
else
    cp "${SRC_DIR}/AGENTS.md" "${TARGET_DIR}/"
    ok "AGENTS.md copied"
fi

# Copy .gitignore only if it doesn't exist
if [[ ! -f "${TARGET_DIR}/.gitignore" ]]; then
    cp "${SRC_DIR}/.gitignore" "${TARGET_DIR}/"
    ok ".gitignore copied"
fi


# --- Hook permissions ---
chmod +x "${TARGET_DIR}/.claude/hooks/"*.sh 2>/dev/null || true

# --- Result ---
echo ""
ok "Claude Code structure added to project."
echo ""
echo "  What was added:"
echo "  CLAUDE.md           ← navigation map and session protocol"
echo "  AGENTS.md           ← universal mirror for Cursor, Windsurf, Copilot"
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
