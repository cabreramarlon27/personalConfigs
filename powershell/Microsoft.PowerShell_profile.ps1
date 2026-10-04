# ============================================
# PowerShell Profile - Migrated from zsh config
# Based on: ~/personalConfigs/zsh/.zshrc
# Date: 2026-10-03
# ============================================

# Oh My Posh - Agnoster theme (same as zsh)
# Calls `oh-my-posh` by name (resolved via PATH) rather than a hardcoded exe
# path, so this profile works unmodified on any machine regardless of where
# oh-my-posh was installed, as long as the installer put it on PATH (winget does).
oh-my-posh init pwsh --config "$env:USERPROFILE\bin\oh-my-posh-theme.json" | Invoke-Expression

# ============================================
# Aliases - Migrated from zsh
# ============================================

# Search command history (replaces: alias gh='history|grep')
# Renamed to 'ghistory' to avoid conflict with GitHub CLI (gh)
function Search-History {
    param([string]$pattern)
    Get-History | Where-Object { $_.CommandLine -like "*$pattern*" }
}
Set-Alias -Name ghistory -Value Search-History

# Git aliases (common from oh-my-zsh git plugin)
function git-status { git status }
function git-add { git add $args }
function git-commit { git commit -m $args }
function git-push { git push $args }
function git-pull { git pull $args }
Set-Alias -Name gst -Value git-status
Set-Alias -Name ga -Value git-add
Set-Alias -Name gcmsg -Value git-commit
Set-Alias -Name gpush -Value git-push -Force
Set-Alias -Name gpull -Value git-pull -Force

# ============================================
# PowerShell Modules (replaces zsh plugins)
# ============================================

# PSReadLine - Command history autosuggestions (replaces zsh-autosuggestions)
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    # These options require PSReadLine 2.1+
    # Uncomment if you upgrade PSReadLine:
    # Set-PSReadLineOption -PredictionSource History
    # Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Emacs
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}

# posh-git - Git status in prompt (replaces zsh git plugin features)
if (Get-Module -ListAvailable -Name posh-git) {
    Import-Module posh-git
}

# Docker completions
if (Get-Command docker -ErrorAction SilentlyContinue) {
    # Docker CLI auto-completion is built-in for PowerShell
}

# ============================================
# Directory Navigation (replaces 'z' plugin)
# ============================================

# ZLocation - Directory jumper like 'z'
if (Get-Module -ListAvailable -Name ZLocation) {
    Import-Module ZLocation
}

# ============================================
# NVM for Windows (replaces nvm initialization)
# ============================================

# Uncomment if you have nvm-windows installed
# $env:NVM_HOME = "$env:APPDATA\nvm"
# $env:NVM_SYMLINK = "$env:ProgramFiles\nodejs"
# if (Test-Path $env:NVM_HOME) {
#     $env:PATH = "$env:NVM_SYMLINK;$env:NVM_HOME;$env:PATH"
# }

# ============================================
# Enhanced ls with colors (Unix-like experience)
# ============================================

function ll { Get-ChildItem -Force $args }
function la { Get-ChildItem -Force $args }

# ============================================
# Utilities
# ============================================

# Quick access to profile editing
function Edit-Profile { notepad $PROFILE }
Set-Alias -Name ep -Value Edit-Profile

# Reload profile
function Reload-Profile {
    . $PROFILE
    Write-Host "Profile reloaded!" -ForegroundColor Green
}
Set-Alias -Name reload -Value Reload-Profile
