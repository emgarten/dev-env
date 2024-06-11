#!/bin/bash

set -xe

# auto install is the suggested way but it doesn't always work for me
# sudo add-apt-repository ppa:graphics-drivers/ppa
# sudo apt-get update
# sudo ubuntu-drivers autoinstall

# Update first
sudo apt-get update

sudo apt install build-essential dkms -y

# Drivers
sudo apt install nvidia-driver-525 -y
sudo apt-get install nvidia-cuda-toolkit -y

# Container toolkit
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
    | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
    | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
    | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list


sudo apt-get install nvidia-container-toolkit -y

sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

echo "Reboot recommended to apply changes."