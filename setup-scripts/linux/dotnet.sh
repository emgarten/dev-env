#/bin/bash

set -xe

echo "Installing dotnet"
# Get linux version
declare repo_version=$(if command -v lsb_release &> /dev/null; then lsb_release -r -s; else grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"'; fi)

# Download Microsoft signing key and repository
wget https://packages.microsoft.com/config/ubuntu/$repo_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

# Install Microsoft signing key and repository
sudo dpkg -i packages-microsoft-prod.deb

# Clean up
rm packages-microsoft-prod.deb

# Update packages
sudo apt update

# sudo apt-get install dotnet-sdk-2.2 -y
# sudo apt-get install dotnet-sdk-3.1 -y
# sudo apt-get install -y dotnet-sdk-5.0
# sudo apt-get install -y dotnet-sdk-6.0
sudo apt-get install -y dotnet-sdk-8.0

# install Azure Artifacts Credential Provider for dotnet restore
wget -qO- https://aka.ms/install-artifacts-credprovider.sh | bash