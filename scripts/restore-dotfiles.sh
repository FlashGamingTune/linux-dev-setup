#!/usr/bin/env bash

source "$(dirname "$0")/lib.sh"

print_header "Restoring Dotfiles"

cp -f dotfiles/.zshrc ~/.zshrc
cp -f dotfiles/.p10k.zsh ~/.p10k.zsh

print_success "Dotfiles restored."
