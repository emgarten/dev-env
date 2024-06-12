#!/bin/bash

set -xe

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

sudo apt update -y
sudo apt install gnome-keyring libsecret-tools -y

if command_exists git-credential-manager; then
    echo "git-credential-manager is already installed"
else
    echo "Installing git-credential-manager..."
    curl -LO https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.5.0/gcm-linux_amd64.2.5.0.deb
    sudo dpkg -i gcm-linux_amd64.2.5.0.deb
    rm gcm-linux_amd64.2.5.0.deb
    echo "git-credential-manager installed successfully"
fi

git-credential-manager configure
git config --global credential.azreposCredentialType oauth