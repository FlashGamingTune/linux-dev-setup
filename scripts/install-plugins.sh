#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "$0")/lib.sh"

print_header "Installing shell and tmux plugins"
plugin_status=0

oh_my_zsh="$HOME/.oh-my-zsh"
if [[ ! -f "$oh_my_zsh/oh-my-zsh.sh" ]]; then
  clone_if_missing https://github.com/ohmyzsh/ohmyzsh.git "$oh_my_zsh" || { print_warning "Could not download Oh My Zsh."; plugin_status=1; }
fi

custom_dir="$oh_my_zsh/custom"
if [[ -f "$oh_my_zsh/oh-my-zsh.sh" ]]; then
  clone_if_missing https://github.com/romkatv/powerlevel10k.git "$custom_dir/themes/powerlevel10k" || { print_warning "Could not download Powerlevel10k."; plugin_status=1; }
  clone_if_missing https://github.com/zsh-users/zsh-autosuggestions.git "$custom_dir/plugins/zsh-autosuggestions" || { print_warning "Could not download zsh-autosuggestions."; plugin_status=1; }
  clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "$custom_dir/plugins/zsh-syntax-highlighting" || { print_warning "Could not download zsh-syntax-highlighting."; plugin_status=1; }
else
  print_warning "Oh My Zsh is unavailable; .zshrc was restored but needs Oh My Zsh to load."
  plugin_status=1
fi

clone_if_missing https://github.com/tmux-plugins/tpm.git "$HOME/.tmux/plugins/tpm" || { print_warning "Could not download the tmux plugin manager."; plugin_status=1; }

if command_exists tmux && [[ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]]; then
  socket="linux-dev-setup-install-$$"
  if TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins" tmux -L "$socket" new-session -d -s setup >/dev/null 2>&1; then
    TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins" tmux -L "$socket" run-shell "$HOME/.tmux/plugins/tpm/bin/install_plugins" || { print_warning "Some tmux plugins did not install."; plugin_status=1; }
    tmux -L "$socket" kill-server >/dev/null 2>&1 || true
  fi
fi
print_success "Plugin setup finished."
exit "$plugin_status"
