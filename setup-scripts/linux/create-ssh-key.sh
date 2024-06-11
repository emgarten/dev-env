#/bin/bash
# Create SSH keys to use for git and ssh
# Since Ed25519 is not supported everywhere generate a 2nd RSA key

set -xe

echo "Creating Ed25519 SSH key"
ssh-keygen -t ed25519 -a 100 -f ~/.ssh/id_ed25519 -q -N ""

echo "Creating RSA SSH key"
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N ""

eval "$(ssh-agent -s)"

ssh-add ~/.ssh/id_ed25519
ssh-add ~/.ssh/id_rsa

echo "Ed25519 public key:"
more ~/.ssh/id_ed25519.pub

echo "RSA public key:"
more ~/.ssh/id_rsa.pub