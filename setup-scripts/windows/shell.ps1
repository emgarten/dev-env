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
# Collect the output before filtering it. Piping a native command straight into
# 'Select-Object -First 1' stops the pipeline as soon as the first line arrives,
# so pwsh never gets to set $LASTEXITCODE and it keeps the stale value from the
# winget calls above - including the "already installed" codes those ignore.
$pwshProfileOutput = @(& pwsh -NoProfile -Command '$PROFILE.CurrentUserCurrentHost')
if ($LASTEXITCODE -ne 0) {
    throw "pwsh exited with code $LASTEXITCODE while reporting its profile path."
}

$pwshProfile = $pwshProfileOutput |
    Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
    Select-Object -First 1
if ([string]::IsNullOrWhiteSpace($pwshProfile)) {
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
