#!/usr/bin/env bash

# Check if kdiff3 is installed
if ! command -v kdiff3 &> /dev/null
then
    echo "KDiff3 not found. Installing..."
    sudo apt-get update -y
    sudo apt-get install -y kdiff3
    echo "KDiff3 installed successfully."
else
    echo "KDiff3 is already installed."
fi

echo "Configuring Git to use KDiff3 as the default mergetool..."

git config --global merge.tool kdiff3
git config --global mergetool.kdiff3.cmd 'kdiff3 --auto --L1 "Base" --L2 "Local" --L3 "Remote" "$BASE" "$LOCAL" "$REMOTE" -o "$MERGED"'
git config --global mergetool.kdiff3.trustExitCode false

git config --global mergetool.prompt false
git config --global mergetool.keepBackup false
git config --global merge.conflictStyle diff3

echo "Git is now configured to use KDiff3 as the default mergetool."
echo "Use 'git mergetool' when you have conflicts to open KDiff3."
