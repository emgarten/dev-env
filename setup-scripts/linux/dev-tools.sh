#!/bin/bash

set -xe

sudo apt update -y
sudo apt install -y software-properties-common build-essential cmake git gitk \
    python3 python3-pip python3-venv curl wget unzip gnupg tmux nano \
    apt-transport-https ca-certificates lsb-release net-tools jq ntpdate