# Prompt for user name and email
$userName = Read-Host -Prompt 'Enter your Git user name'
$userEmail = Read-Host -Prompt 'Enter your Git user email'

# Set Git global configuration
git config --global user.name "$userName"
git config --global user.email "$userEmail"
git config --global push.default current
git config --global core.editor "code --wait"
git config --global pull.rebase true
git config --global diff.algorithm patience
git config --global rerere.enabled true

Write-Output "Git configuration updated successfully."