$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot 'common.ps1')

Assert-WinGet

# GitHub Copilot CLI. The package declares a dependency on PowerShell 7, which
# Copilot CLI requires on Windows, so winget pulls that in as well.
Install-WinGetPackage 'GitHub.Copilot'

Write-Output "Copilot CLI installed. Open a new shell, run 'copilot', then use /login to authenticate."
