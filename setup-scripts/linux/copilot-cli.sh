#!/bin/bash

set -xe

# The installer downloads a release tarball, so it needs one of curl or wget.
if ! command -v curl >/dev/null 2>&1; then
    echo "curl is required, run dev-tools.sh first" >&2
    exit 1
fi

# A non-root install lands in $PREFIX/bin, which defaults to ~/.local/bin.
# Creating that directory and putting it on PATH before running the installer
# means it finds copilot on PATH when it finishes, so it skips the interactive
# "would you like to add it to your profile?" prompt it otherwise reads from
# /dev/tty. The persistent wiring is done below instead.
INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"
export PATH="$INSTALL_DIR:$PATH"

curl -fsSL https://gh.io/copilot-install | bash

# Ubuntu's stock ~/.profile only adds ~/.local/bin to PATH when that directory
# already exists at login, and fish never reads ~/.profile at all. The installer
# picks a profile from $SHELL, which lands on the wrong file once fish is the
# login shell, so configure both shells here the same way nvm.sh does.
if ! grep -qs 'dev-env setup-scripts/linux/copilot-cli.sh' "$HOME/.bashrc"; then
    cat >> "$HOME/.bashrc" <<'EOF'

# Written by dev-env setup-scripts/linux/copilot-cli.sh
# Guarded so nested shells do not keep prepending the same entry.
case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$HOME/.local/bin:$PATH" ;;
esac
EOF
fi

# fish_add_path is idempotent, so re-running this script will not duplicate the
# entry. Skipped when fish is absent, which is fine because fish-starship.sh has
# not run yet in that case; re-run this script afterwards to configure it.
if command -v fish >/dev/null 2>&1; then
    fish -c "fish_add_path -U '$INSTALL_DIR'"
fi

copilot version
