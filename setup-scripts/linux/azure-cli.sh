#!/bin/bash

set -xe

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# add kubectl and kubelogin
mkdir -p ~/bin
az aks install-cli --install-location ~/bin/kubectl --kubelogin-install-location ~/bin/kubelogin