#!/bin/bash

read -p "Enter your Git user name: " git_user_name
read -p "Enter your Git user email: " git_user_email

git config --global user.name "$git_user_name"
git config --global user.email "$git_user_email"
git config --global push.default current
git config --global core.editor "nano"
git config --global pull.rebase true
git config --global diff.algorithm patience
git config --global rerere.enabled true
git config --global fetch.prune true
git config --global mergetool.keepBackup false

echo "Git configuration updated successfully."
more ~/.gitconfig