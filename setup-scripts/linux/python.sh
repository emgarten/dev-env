#!/bin/bash

set -e  # Exit on error

echo "Updating system and installing prerequisites..."
sudo apt update
sudo apt install -y software-properties-common

echo "Adding deadsnakes PPA..."
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update

echo "Installing Python 3.12 and related packages..."
sudo apt install -y python3.12 python3.12-venv python3.12-dev

echo "Verifying Python 3.12 installation..."
python3.12 --version

# OPTIONAL: Set python3 to point to python3.12
read -p "Do you want to set Python 3.12 as the default python3? (y/n): " set_default
if [[ "$set_default" == "y" ]]; then
    echo "Setting Python 3.12 as the default python3..."
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1
    sudo update-alternatives --config python3
    echo "Now using: $(python3 --version)"
else
    echo "Skipping default python3 update."
fi

# install UV
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "Done."
