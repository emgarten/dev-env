$ErrorActionPreference = "Stop"

# Starship shell
winget install starship

# Add to $PROFILE
# Invoke-Expression (&starship init powershell)

# K8s viewer
winget install openlens

# alternative command line k8s viewer
# winget install Derailed.k9s

# az cli
winget install Microsoft.AzureCLI

# install kubectl and kubelogin
az aks install-cli

# helm
winget install Helm.Helm

# Additional tools
# winget install Microsoft.Azure.StorageExplorer
# winget install Microsoft.WindowsTerminal
# winget install Microsoft.Git 
