# ============================================
# Bootstrap script for the PowerShell config in this folder.
# Run from a normal (non-admin) PowerShell window:
#   .\setup.ps1
# ============================================

$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot

# 1. oh-my-posh - installed via winget so it lands on PATH automatically,
#    which is what lets the profile call `oh-my-posh` by name instead of
#    a hardcoded exe path.
if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Write-Host "Installing oh-my-posh via winget..." -ForegroundColor Cyan
    winget install JanDeDobbeleer.OhMyPosh --source winget -e `
        --accept-package-agreements --accept-source-agreements
    Write-Host "oh-my-posh installed. You may need to restart your terminal for PATH changes to take effect." -ForegroundColor Yellow
} else {
    Write-Host "oh-my-posh already on PATH, skipping install." -ForegroundColor Green
}

# 2. Required PowerShell modules (CurrentUser scope, no admin needed)
foreach ($module in 'PSReadLine', 'posh-git', 'ZLocation') {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Host "Installing module $module..." -ForegroundColor Cyan
        Install-Module -Name $module -Scope CurrentUser -Force -AllowClobber
    } else {
        Write-Host "Module $module already installed, skipping." -ForegroundColor Green
    }
}

# 3. Theme JSON - the profile expects it at ~\bin\oh-my-posh-theme.json
$binDir = Join-Path $env:USERPROFILE 'bin'
if (-not (Test-Path $binDir)) {
    New-Item -ItemType Directory -Path $binDir | Out-Null
}
Copy-Item -Path (Join-Path $here 'oh-my-posh-theme.json') -Destination $binDir -Force
Write-Host "Copied oh-my-posh-theme.json to $binDir" -ForegroundColor Green

# 4. Profile - back up any existing profile instead of silently overwriting it
if (Test-Path $PROFILE) {
    $backup = "$PROFILE.bak-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item -Path $PROFILE -Destination $backup
    Write-Host "Existing profile backed up to $backup" -ForegroundColor Yellow
} else {
    $profileDir = Split-Path $PROFILE -Parent
    if (-not (Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir | Out-Null
    }
}
Copy-Item -Path (Join-Path $here 'Microsoft.PowerShell_profile.ps1') -Destination $PROFILE -Force
Write-Host "Profile installed at $PROFILE" -ForegroundColor Green

Write-Host "`nDone. Restart your terminal (or run '. `$PROFILE') to pick up the changes." -ForegroundColor Cyan
