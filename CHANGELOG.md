# Changelog

All notable changes to this template. / Mudanças relevantes deste template.
Format: [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

## [1.0.0] - 2026-11-15

### Added / Adicionado
- Community health files: `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`,
  `SUPPORT.md`, issue forms, pull request template and a lightweight CI.
- `permissions.deny` for `.env*`, `*.pem`, `*.key` and SSH keys in `.claude/settings.json`; `block-destructive.sh` also blocks reading them through the shell (best-effort).

### Changed / Alterado
- `adopt.sh` / `adopt.ps1`: an existing `.claude/` is no longer overwritten by default. Only missing files are added; a differing `settings.json` is saved as `settings.template.json` for manual merge. Overwrite is opt-in and saves a `.claude.bak-<timestamp>` backup first.
- `adopt.sh` installs the copy it was run from instead of cloning the default branch again, lists the hooks it will install, and accepts `TEMPLATE_REF` when run as a lone file. Install commands in the docs now clone the `v1.0.0` tag.

### Fixed / Corrigido
- `block-destructive.sh` no longer lets every command through when `jq` is missing (falls back to `python3`, then to matching the raw hook input).
- The secret-read guard no longer blocks `process.env.X` searches or files such as `config.env.ts`; `.pub` keys are allowed.
