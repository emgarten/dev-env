$ErrorActionPreference = "Stop"

# PowerShell 7.4+ turns any non-zero native exit code into a terminating error,
# which would abort on the "already installed" codes handled below.
$PSNativeCommandUseErrorActionPreference = $false

# winget exit codes that mean the package is already present, not a failure.
$WinGetAlreadyInstalled = @(
    -1978335189, # 0x8A15002B APPINSTALLER_CLI_ERROR_UPDATE_NOT_APPLICABLE
    -1978335135  # 0x8A150061 APPINSTALLER_CLI_ERROR_PACKAGE_ALREADY_INSTALLED
)

function Install-WinGetPackage {
    param([Parameter(Mandatory = $true)][string]$Id)

    winget install --id $Id --exact --silent `
        --accept-package-agreements --accept-source-agreements --disable-interactivity

    if ($LASTEXITCODE -ne 0 -and $WinGetAlreadyInstalled -notcontains $LASTEXITCODE) {
        throw "winget install $Id failed with exit code $LASTEXITCODE"
    }
}

# winget updates the persisted PATH, not the copy this process started with.
# Merge in anything new rather than replacing, so process-only entries survive.
function Update-SessionPath {
    $current = @($env:Path -split ';' | Where-Object { $_ })
    $persisted = @(
        [Environment]::GetEnvironmentVariable('Path', 'Machine')
        [Environment]::GetEnvironmentVariable('Path', 'User')
    ) -join ';'

    $missing = @($persisted -split ';' | Where-Object { $_ -and $current -notcontains $_ })
    if ($missing.Count -gt 0) {
        $env:Path = ($current + $missing) -join ';'
    }
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget was not found. Install 'App Installer' from the Microsoft Store first."
}

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
