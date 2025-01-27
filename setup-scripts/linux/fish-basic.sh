#!/bin/bash

set -xe

# install fish and required packages
sudo apt install fish -y

mkdir -p ~/bin
mkdir -p ~/.config/fish
echo "set -g fish_greeting" > ~/.config/fish/config.fish
echo "set -gx EDITOR nano" >> ~/.config/fish/config.fish
echo "set -gx VISUAL nano" >> ~/.config/fish/config.fish
echo "fish_add_path ~/bin" >> ~/.config/fish/config.fish
echo "fish_add_path ~/.local/bin" >> ~/.config/fish/config.fish

# Set fish as the default shell
chsh -s /usr/bin/fish
