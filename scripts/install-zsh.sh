#!/usr/bin/env bash

source "$(dirname "$0")/lib.sh"

print_header "Installing Zsh"

print_info "Installing Zsh..."

sudo apt install -y zsh

print_success "Zsh installed."
