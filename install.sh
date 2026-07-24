#!/usr/bin/env bash

set -e

# -------------------------------------------------
# Linux Development Setup
# Main Installer
# -------------------------------------------------

source "$(dirname "$0")/scripts/lib.sh"

print_header "Linux Development Setup"

require_sudo

bash scripts/install-terminal.sh
bash scripts/install-git.sh
bash scripts/install-zsh.sh
bash scripts/install-fonts.sh
bash scripts/install-neovim.sh
bash scripts/install-devtools.sh
bash scripts/restore-dotfiles.sh

print_success "Installation completed successfully!"
