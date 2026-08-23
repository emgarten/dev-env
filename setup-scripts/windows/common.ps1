# Shared helpers for the Windows setup scripts.
# Dot-source it: . (Join-Path $PSScriptRoot 'common.ps1')

# PowerShell 7.4+ turns any non-zero native exit code into a terminating error,
# which would abort on the "already installed" codes handled below.
$PSNativeCommandUseErrorActionPreference = $false

# winget exit codes that mean the package is already present, not a failure.
$WinGetAlreadyInstalled = @(
    -1978335189, # 0x8A15002B APPINSTALLER_CLI_ERROR_UPDATE_NOT_APPLICABLE
    -1978335135  # 0x8A150061 APPINSTALLER_CLI_ERROR_PACKAGE_ALREADY_INSTALLED
)

function Assert-WinGet {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw "winget was not found. Install 'App Installer' from the Microsoft Store first."
    }
}

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
