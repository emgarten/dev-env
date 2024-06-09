#!/bin/bash

set -xe

# Install from the official script
# https://docs.docker.com/engine/install/ubuntu/
curl -fsSL https://get.docker.com | sudo sh

# Add the current user to the docker group
sudo usermod -aG docker $(whoami)

# Start docker
sudo service docker start

# Test the installation
sudo docker run hello-world