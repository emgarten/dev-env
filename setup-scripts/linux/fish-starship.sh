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
# nvm.fish reads nvm_data at startup from conf.d, which fish loads before
# config.fish, so this snippet has to exist before the plugin is installed.
mkdir -p ~/.config/fish/conf.d
cat > ~/.config/fish/conf.d/00-nvm.fish <<'EOF'
# Written by dev-env setup-scripts/linux/fish-starship.sh
#
# Runs before conf.d/nvm.fish, which only sets these when they are unset.
# nvm.fish stores runtimes at $nvm_data/<version>/bin, the same layout the POSIX
# nvm uses for $NVM_DIR/versions/node/<version>/bin, so pointing it there lets
# bash and fish share one set of installed Node versions.
#
# WARNING: `fisher remove jorgebucaran/nvm.fish` runs `rm -rf $nvm_data`, which
# would delete every Node version shared with bash. Erase nvm_data first.
set -q NVM_DIR; or set -gx NVM_DIR $HOME/.nvm
set -q nvm_data; or set -g nvm_data $NVM_DIR/versions/node
EOF

# fisher is a fish function, so it cannot be invoked from this bash script.
fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
fish -c 'fisher install jorgebucaran/nvm.fish'