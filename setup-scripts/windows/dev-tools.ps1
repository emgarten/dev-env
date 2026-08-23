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

Install-WinGetPackage 'Python.Python.3.12'

# GNU make
Install-WinGetPackage 'ezwinports.make'

# K8s viewer
Install-WinGetPackage 'Derailed.k9s'

# helm
Install-WinGetPackage 'Helm.Helm'

# az cli
Install-WinGetPackage 'Microsoft.AzureCLI'

# install kubectl and kubelogin
Update-SessionPath
if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    throw "az was not found on PATH after installing the Azure CLI. Open a new shell and run 'az aks install-cli'."
}

az aks install-cli
if ($LASTEXITCODE -ne 0) {
    throw "az aks install-cli failed with exit code $LASTEXITCODE"
}

Write-Output "Dev tools installed. Open a new shell to pick up PATH changes."
