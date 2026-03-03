#!/usr/bin/env bash
# adopt.sh — adds Claude Code structure to an existing project
# Adiciona a estrutura Claude Code a um projeto existente
#
# USAGE / USO:
#   gh repo clone [OWNER]/template-claude-code-open /tmp/cc-template -- --depth=1 --quiet \
#     && bash /tmp/cc-template/adopt.sh; rm -rf /tmp/cc-template
#
#   or, with the repo already cloned locally / ou, com o repo já clonado localmente:
#   bash /path/to/template-claude-code-open/adopt.sh

set -euo pipefail

TEMPLATE_REPO="[OWNER]/template-claude-code-open"
TEMP_DIR=$(mktemp -d)
TARGET_DIR="${PWD}"

# --- Colors / Cores ---
info()  { echo -e "\033[34m[INFO]\033[0m $*"; }
ok()    { echo -e "\033[32m[ OK ]\033[0m $*"; }
warn()  { echo -e "\033[33m[WARN]\033[0m $*"; }
erro()  { echo -e "\033[31m[ERROR]\033[0m $*" >&2; exit 1; }

# --- Validations / Validações ---
[[ ! -d "${TARGET_DIR}/.git" ]] && erro "Run this script at the root of a git repository. / Execute este script na raiz de um repositório git."
command -v gh &>/dev/null || erro "GitHub CLI (gh) not found. Install at: https://cli.github.com"

info "Project detected / Projeto detectado: ${TARGET_DIR}"
info "Downloading template structure / Baixando estrutura do template..."

# Silent template clone / Clone silencioso do template
gh repo clone "$TEMPLATE_REPO" "$TEMP_DIR" -- --depth=1 --quiet 2>/dev/null \
  || erro "Failed to clone template. Check access to repo: ${TEMPLATE_REPO} / Falha ao clonar o template. Verifique acesso ao repo: ${TEMPLATE_REPO}"

# --- Files to copy / Arquivos a copiar ---
# Only copies .claude/ structure and CLAUDE.md
# Só copia a estrutura .claude/ e o CLAUDE.md
# Does NOT overwrite: README.md, docs/, QUICKSTART.md — those are from the template, not the project
# NÃO sobrescreve: README.md, docs/, QUICKSTART.md — esses são do template, não do projeto

if [[ -d "${TARGET_DIR}/.claude" ]]; then
    warn ".claude/ already exists in this project. / .claude/ já existe neste projeto."
    read -rp "Overwrite? Existing files will be lost. / Deseja sobrescrever? Arquivos existentes serão perdidos. [y/N / s/N] " resposta
    [[ "${resposta,,}" != "y" && "${resposta,,}" != "s" ]] && { info "Operation cancelled. / Operação cancelada."; rm -rf "$TEMP_DIR"; exit 0; }
fi

cp -r "${TEMP_DIR}/.claude" "${TARGET_DIR}/"
ok ".claude/ copied / copiado"

if [[ -f "${TARGET_DIR}/CLAUDE.md" ]]; then
    warn "CLAUDE.md already exists — keeping existing. / CLAUDE.md já existe — mantendo o existente."
else
    cp "${TEMP_DIR}/CLAUDE.md" "${TARGET_DIR}/"
    ok "CLAUDE.md copied / copiado"
fi

# Copy .gitignore only if it doesn't exist / Copia .gitignore só se não existir
if [[ ! -f "${TARGET_DIR}/.gitignore" ]]; then
    cp "${TEMP_DIR}/.gitignore" "${TARGET_DIR}/"
    ok ".gitignore copied / copiado"
fi

rm -rf "$TEMP_DIR"

# --- Hook permissions / Permissões dos hooks ---
chmod +x "${TARGET_DIR}/.claude/hooks/"*.sh 2>/dev/null || true

# --- Result / Resultado ---
echo ""
ok "Claude Code structure added to project. / Estrutura Claude Code adicionada ao projeto."
echo ""
echo "  Next step / Próximo passo:"
echo "  1. Open Claude Code at project root: claude"
echo "  2. Run / Execute: project-adopt"
echo ""
echo "  The agent will map the existing codebase and configure memory"
echo "  with the conventions and stack already in the code."
echo "  O agente vai mapear o codebase existente e configurar a memória"
echo "  com as convenções e stack que já estão no código."
echo ""
