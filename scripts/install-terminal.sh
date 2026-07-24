#!/usr/bin/env bash

source "$(dirname "$0")/lib.sh"

print_header "Installing Terminal Tools"

print_info "Updating package list..."
sudo apt update

print_info "Installing packages..."

sudo apt install -y \
  zsh \
  curl \
  wget \
  eza \
  bat \
  fzf \
  ripgrep \
  fd-find \
  zoxide \
  btop \
  tree

print_success "Terminal tools installed."
