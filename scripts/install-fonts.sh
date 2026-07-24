#!/usr/bin/env bash

source "$(dirname "$0")/lib.sh"

print_header "Installing Fonts"

mkdir -p ~/.local/share/fonts

cp -r fonts/* ~/.local/share/fonts/ 2>/dev/null || true

fc-cache -fv

print_success "Fonts installed."
