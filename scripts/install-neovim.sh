#!/usr/bin/env bash

source "$(dirname "$0")/lib.sh"

print_header "Installing Neovim"

print_info "Installing Neovim..."

sudo apt install -y neovim

print_success "Neovim installed."
