#!/bin/bash

set -xe

# install fish and required packages
bash ./fish-basic.sh

# Install starship
curl -sS https://starship.rs/install.sh | sh

echo "starship init fish | source" >> ~/.config/fish/config.fish

# for more see https://starship.rs/presets/
starship preset no-nerd-font -o ~/.config/starship.toml

# If fonts are available on your terminal you can use:
# starship preset nerd-font-symbols -o ~/.config/starship.toml
# install the fira code font
# sudo apt install unzip -y
# mkdir -p ~/.locset fish_greetingal/share/fonts
# pushd ~/.local/share/fonts
# wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip
# unzip FiraCode.zip
# rm FiraCode.zip
# fc-cache -fv

# Plugins
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
omf install bass
omf install https://github.com/fabioantunes/fish-nvm