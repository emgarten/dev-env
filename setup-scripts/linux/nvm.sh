#!/bin/bash

set -xe

NVM_VERSION="v0.40.6"

if ! command -v curl >/dev/null 2>&1; then
    echo "curl is required, run dev-tools.sh first" >&2
    exit 1
fi

# The installer picks which profile to modify from $SHELL. Once fish is the
# login shell it matches neither the bash nor the zsh branch and falls back to
# ~/.profile, which bash only reads for login shells, so nvm never loads in an
# interactive bash session. PROFILE forces the target, and the file has to
# exist for the installer to accept it.
touch "$HOME/.bashrc"
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | PROFILE="$HOME/.bashrc" bash

# Machines provisioned by the older version of this script have the block in
# ~/.profile as well. The installer only de-duplicates within its target file,
# so the stale copy has to be removed here or nvm gets loaded twice.
if [ -f "$HOME/.profile" ] && grep -q 'NVM_DIR' "$HOME/.profile"; then
    cp "$HOME/.profile" "$HOME/.profile.nvm-backup"
    sed -i '/NVM_DIR/d' "$HOME/.profile"
fi

# Only affects this script, which is what lets nvm run below.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Without an installed runtime and a default alias there is no node or npm on a
# clean machine, and new shells have nothing to activate.
nvm install --lts
nvm alias default 'lts/*'

# fish gets its default from nvm.fish's universal variable rather than nvm's
# alias file. Setting it here keeps both shells on the same version, and is
# harmless when fish-starship.sh has not installed the plugin yet.
if command -v fish >/dev/null 2>&1; then
    nvm_default_version="$(nvm version default)"
    fish -c "set -U nvm_default_version $nvm_default_version"
fi

node --version
npm --version
