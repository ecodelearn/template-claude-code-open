<#
.SYNOPSIS
  Adota o template-claude-code-open em um projeto existente (Windows).
  Copia .claude/, CLAUDE.md, AGENTS.md e .gitignore para o diretório atual.

.DESCRIPTION
  Script PowerShell puro — sem dependência de WSL, Git Bash ou bash.
  Deve ser executado na raiz do projeto destino.

.EXAMPLE
  gh repo clone ecodelearn/template-claude-code-open $env:TEMP\cc-template -- --depth=1 --quiet
  powershell -ExecutionPolicy Bypass -File "$env:TEMP\cc-template\adopt.ps1"
  Remove-Item "$env:TEMP\cc-template" -Recurse -Force
#>

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

Write-Host "=== Adopt template-claude-code-open ===" -ForegroundColor Cyan
Write-Host "Target: $(Get-Location)" -ForegroundColor Cyan
Write-Host ""

# .claude/
$targetClaude = Join-Path (Get-Location) ".claude"
if (Test-Path $targetClaude) {
    $confirm = Read-Host ".claude/ already exists. Overwrite? (y/N)"
    if ($confirm -ne "y") { Write-Host "Skipping .claude/" -ForegroundColor Yellow }
    else {
        Copy-Item -Path (Join-Path $ScriptDir ".claude") -Destination (Get-Location) -Recurse -Force
        Write-Host "  .claude/ overwritten" -ForegroundColor Green
    }
} else {
    Copy-Item -Path (Join-Path $ScriptDir ".claude") -Destination (Get-Location) -Recurse
    Write-Host "  .claude/ copied" -ForegroundColor Green
}

# CLAUDE.md
$claudeTarget = Join-Path (Get-Location) "CLAUDE.md"
if (Test-Path $claudeTarget) {
    $confirm = Read-Host "CLAUDE.md already exists. Overwrite? (y/N)"
    if ($confirm -ne "y") { Write-Host "Skipping CLAUDE.md" -ForegroundColor Yellow }
    else {
        Copy-Item -Path (Join-Path $ScriptDir "CLAUDE.md") -Destination $claudeTarget -Force
        Write-Host "  CLAUDE.md overwritten" -ForegroundColor Green
    }
} else {
    Copy-Item -Path (Join-Path $ScriptDir "CLAUDE.md") -Destination (Get-Location)
    Write-Host "  CLAUDE.md copied" -ForegroundColor Green
}

# AGENTS.md
$agentsTarget = Join-Path (Get-Location) "AGENTS.md"
if (Test-Path $agentsTarget) {
    $confirm = Read-Host "AGENTS.md already exists. Overwrite? (y/N)"
    if ($confirm -ne "y") { Write-Host "Skipping AGENTS.md" -ForegroundColor Yellow }
    else {
        Copy-Item -Path (Join-Path $ScriptDir "AGENTS.md") -Destination $agentsTarget -Force
        Write-Host "  AGENTS.md overwritten" -ForegroundColor Green
    }
} else {
    Copy-Item -Path (Join-Path $ScriptDir "AGENTS.md") -Destination (Get-Location)
    Write-Host "  AGENTS.md copied" -ForegroundColor Green
}

# .gitignore
$gitignoreTarget = Join-Path (Get-Location) ".gitignore"
if (Test-Path $gitignoreTarget) {
    $confirm = Read-Host ".gitignore already exists. Overwrite? (y/N)"
    if ($confirm -ne "y") { Write-Host "Skipping .gitignore" -ForegroundColor Yellow }
    else {
        Copy-Item -Path (Join-Path $ScriptDir ".gitignore") -Destination $gitignoreTarget -Force
        Write-Host "  .gitignore overwritten" -ForegroundColor Green
    }
} else {
    Copy-Item -Path (Join-Path $ScriptDir ".gitignore") -Destination (Get-Location)
    Write-Host "  .gitignore copied" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Done! ===" -ForegroundColor Cyan
Write-Host "Run Claude Code and execute: /project-adopt" -ForegroundColor White
