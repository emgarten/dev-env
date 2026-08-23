$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot 'common.ps1')

Assert-WinGet

# PowerShell 7, the shell starship is configured for below
Install-WinGetPackage 'Microsoft.PowerShell'

# Starship prompt
Install-WinGetPackage 'Starship.Starship'

Update-SessionPath

if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    throw "pwsh was not found on PATH after installing PowerShell 7. Open a new shell and re-run this script."
}

# Ask pwsh for its own profile path. This script may be running under Windows
# PowerShell, whose $PROFILE points at WindowsPowerShell instead, and Documents
# is often redirected to OneDrive.
$pwshProfile = & pwsh -NoProfile -Command '$PROFILE.CurrentUserCurrentHost' | Select-Object -First 1
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($pwshProfile)) {
    throw "Could not determine the PowerShell 7 profile path."
}
$pwshProfile = $pwshProfile.Trim()

# -Force also creates the containing directory
if (-not (Test-Path -LiteralPath $pwshProfile)) {
    New-Item -ItemType File -Path $pwshProfile -Force | Out-Null
}

$starshipInit = 'Invoke-Expression (&starship init powershell)'
$profileContent = Get-Content -LiteralPath $pwshProfile -Raw
if ([string]::IsNullOrEmpty($profileContent)) {
    $profileContent = ''
}

if ($profileContent -notmatch 'starship init powershell') {
    if ($profileContent -and -not $profileContent.EndsWith("`n")) {
        $profileContent += [Environment]::NewLine
    }
    $profileContent += $starshipInit + [Environment]::NewLine
    Set-Content -LiteralPath $pwshProfile -Value $profileContent -NoNewline
    Write-Output "Added starship init to $pwshProfile"
}
else {
    Write-Output "starship init already present in $pwshProfile"
}

Write-Output "Done. Start pwsh to use the starship prompt."
