# powershell

PowerShell profile and oh-my-posh theme, migrated from the zsh setup in
[`../zsh`](../zsh). Equivalent to oh-my-zsh + the `agnoster` theme.

## Contents

- `Microsoft.PowerShell_profile.ps1` - the `$PROFILE` script: oh-my-posh init, git/history aliases, module imports (PSReadLine, posh-git, ZLocation).
- `oh-my-posh-theme.json` - Agnoster-style theme, copied to `~\bin\oh-my-posh-theme.json`.
- `setup.ps1` - installs oh-my-posh + required modules and deploys the two files above.

## Setup on a new machine

```powershell
.\setup.ps1
```

This installs oh-my-posh via winget (so it ends up on PATH - the profile
calls it by name, not by a hardcoded path), installs the `PSReadLine`,
`posh-git`, and `ZLocation` modules for the current user, copies the theme
JSON to `~\bin`, and copies the profile to `$PROFILE` (backing up any
existing profile first).

## Known caveat: PSReadLine version on Windows PowerShell 5.1

Windows PowerShell 5.1 ships an inbox `PSReadLine` 2.0.0 in
`C:\Program Files\WindowsPowerShell\Modules`, which sits earlier on
`$PSModulePath` than a newer user-installed version and gets loaded by the
console host before the profile even runs. That means predictive
IntelliSense options (`PredictionSource`/`PredictionViewStyle`, requires
2.1+) silently fail to apply even after installing a newer PSReadLine,
and the old version can't be replaced in-session - not even with
`-Force` - because the DLL is already loaded.

To actually fix it: close **every** open PowerShell window (the DLL is
locked while any process has it loaded), then as admin delete or rename
`C:\Program Files\WindowsPowerShell\Modules\PSReadline\2.0.0` (and `1.1`
if present), then uncomment the two `Set-PSReadLineOption` lines in the
profile. Not required for oh-my-posh itself to work.
