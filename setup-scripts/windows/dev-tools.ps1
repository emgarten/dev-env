$ErrorActionPreference = "Stop"

# Starship shell
winget install starship

# Add to $PROFILE
# Invoke-Expression (&starship init powershell)

winget install Python.Python.3.12

# K8s viewer
winget install openlens
winget install Derailed.k9s

# helm
winget install Helm.Helm

# Additional tools
# winget install Microsoft.Azure.StorageExplorer
# winget install Microsoft.WindowsTerminal
# winget install Microsoft.Git 

# az cli
winget install Microsoft.AzureCLI

# install kubectl and kubelogin
az aks install-cli