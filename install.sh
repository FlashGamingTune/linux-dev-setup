#!/usr/bin/env bash

set -uo pipefail
repo_root="$(cd -- "$(dirname -- "$0")" && pwd)"
source "$repo_root/scripts/lib.sh"

usage() {
  cat <<'EOF'
Linux Dev Setup

Usage: ./install.sh [--dotfiles-only] [--packages-only] [--help]

  --dotfiles-only  Restore configuration and plugins without installing packages.
  --packages-only  Install packages without touching configuration files.
  --help           Show this help.
EOF
}

mode=all
while (($#)); do
  case "$1" in
    --dotfiles-only) mode=dotfiles ;;
    --packages-only) mode=packages ;;
    --help|-h) usage; exit 0 ;;
    *) print_error "Unknown option: $1"; usage; exit 2 ;;
  esac
  shift
done

if (( EUID == 0 )); then
  print_error "Run this script as your normal user. It uses sudo only when packages are needed."
  exit 2
fi

print_header "Linux Dev Setup"
package_status=0
if [[ "$mode" != dotfiles ]]; then
  bash "$repo_root/scripts/install-packages.sh" || package_status=$?
fi

plugin_status=0
config_status=0
if [[ "$mode" != packages ]]; then
  bash "$repo_root/scripts/restore-dotfiles.sh" || config_status=$?
  bash "$repo_root/scripts/install-plugins.sh" || plugin_status=$?
  if command_exists zsh && [[ -t 0 ]] && command_exists chsh && [[ "${LINUX_SETUP_NO_CHSH:-0}" != 1 ]]; then
    printf 'Make Zsh your default login shell? [Y/n] '
    read -r answer
    if [[ -z "$answer" || "$answer" =~ ^[Yy] ]]; then
      chsh -s "$(command -v zsh)" || print_warning "Could not change the login shell; use 'chsh -s $(command -v zsh)' later."
    fi
  fi
fi

if (( package_status || plugin_status || config_status )); then
  print_warning "Setup is partial. Configs were backed up before replacement; review messages above and rerun after fixing any errors."
  (( config_status )) && exit "$config_status"
  (( plugin_status )) && exit "$plugin_status"
  exit "$package_status"
fi

print_success "Setup finished. Start a new terminal or run 'zsh'. In tmux, press Ctrl+a then I once to install its plugins."
