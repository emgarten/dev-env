#/bin/bash
# Create an SSH key to use for git and ssh

set -xe

echo "Creating ssh key"
ssh-keygen -t ed25519 -a 100 -f ~/.ssh/id_ed25519 -q -N ""

eval "$(ssh-agent -s)"

ssh-add ~/.ssh/id_ed25519

more ~/.ssh/id_ed25519.pub