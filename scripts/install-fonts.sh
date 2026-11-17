#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "$0")/lib.sh"
font_dir="$REPO_ROOT/fonts"
if [[ ! -d "$font_dir" ]]; then
  print_warning "No bundled fonts are present; install a Nerd Font if you want Powerlevel10k icons."
  exit 0
fi
mkdir -p "$HOME/.local/share/fonts"
cp -a "$font_dir/." "$HOME/.local/share/fonts/"
command_exists fc-cache && fc-cache -f "$HOME/.local/share/fonts"
print_success "Fonts installed."
