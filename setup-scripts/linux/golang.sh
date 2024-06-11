#!/bin/bash
set -xe

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Go is already installed
if command_exists go; then
    echo "Golang is already installed."
    go version
    exit 0
fi

sudo apt-get update -y
sudo apt-get install -y software-properties-common

echo "Adding Go PPA..."
sudo add-apt-repository -y ppa:longsleep/golang-backports
sudo apt-get update -y

# Install Golang
sudo apt-get install -y golang-go
go version