$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot 'common.ps1')

Assert-WinGet

# az cli, required by 'az aks install-cli' below
Install-WinGetPackage 'Microsoft.AzureCLI'

# helm
Install-WinGetPackage 'Helm.Helm'

# K8s viewer
Install-WinGetPackage 'Derailed.k9s'

# install kubectl and kubelogin
Update-SessionPath
if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    throw "az was not found on PATH after installing the Azure CLI. Open a new shell and run 'az aks install-cli'."
}

az aks install-cli
if ($LASTEXITCODE -ne 0) {
    throw "az aks install-cli failed with exit code $LASTEXITCODE"
}

Write-Output "Kubernetes tools installed. Open a new shell to pick up PATH changes."
