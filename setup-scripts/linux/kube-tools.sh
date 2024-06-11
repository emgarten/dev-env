#!/bin/bash

set -xe

# Script assumes that ~/bin is on the PATH

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Create ~/bin directory if it doesn't exist
mkdir -p ~/bin

# Install kubectl
if command_exists kubectl; then
    echo "kubectl is already installed"
else
    echo "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl ~/bin/
    echo "kubectl installed successfully"
fi

# Install Helm
if command_exists helm; then
    echo "Helm is already installed"
else
    echo "Installing Helm..."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    echo "Helm installed successfully"
fi

# Install k9s
if command_exists k9s; then
    echo "k9s is already installed"
else
    echo "Installing k9s..."
    K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
    curl -Lo k9s.tgz https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz
    tar -xzf k9s.tgz k9s
    chmod +x k9s
    mv k9s ~/bin/
    rm k9s.tgz
    echo "k9s installed successfully"
fi

# Install Minikube
if command_exists minikube; then
    echo "Minikube is already installed"
else
    echo "Installing Minikube..."
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    chmod +x minikube
    mv minikube ~/bin/
    echo "Minikube installed successfully"
fi

echo "done!"