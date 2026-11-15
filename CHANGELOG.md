# Changelog

All notable changes to this template. / Mudanças relevantes deste template.
Format: [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Added / Adicionado
- Community health files: `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`,
  `SUPPORT.md`, issue forms, pull request template and a lightweight CI.
- `permissions.deny` for `.env*`, `*.pem`, `*.key` and SSH keys in `.claude/settings.json`; `block-destructive.sh` also blocks reading them through the shell (best-effort).

### Changed / Alterado
- `adopt.sh` / `adopt.ps1`: an existing `.claude/` is no longer overwritten by default. Only missing files are added; a differing `settings.json` is saved as `settings.template.json` for manual merge. Overwrite is opt-in and saves a `.claude.bak-<timestamp>` backup first.
