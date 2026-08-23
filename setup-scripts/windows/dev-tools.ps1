$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot 'common.ps1')

Assert-WinGet

Install-WinGetPackage 'Python.Python.3.12'

# GNU make
Install-WinGetPackage 'ezwinports.make'

# az cli
Install-WinGetPackage 'Microsoft.AzureCLI'

Write-Output "Dev tools installed. Open a new shell to pick up PATH changes."
