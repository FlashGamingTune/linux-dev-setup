#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "$0")/lib.sh"

print_header "Restoring configuration"
backup_and_copy "$REPO_ROOT/dotfiles/.zshrc" "$HOME/.zshrc"
backup_and_copy "$REPO_ROOT/dotfiles/.p10k.zsh" "$HOME/.p10k.zsh"
backup_and_copy "$REPO_ROOT/dotfiles/.tmux.conf" "$HOME/.tmux.conf"

zsh_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
for file in aliases.zsh environment.zsh exports.zsh functions.zsh extra.zsh; do
  backup_and_copy "$REPO_ROOT/dotfiles/$file" "$zsh_config_dir/$file"
done

print_success "Zsh and tmux configuration restored."
