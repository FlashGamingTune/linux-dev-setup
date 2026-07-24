#!/usr/bin/env bash

source "$(dirname "$0")/lib.sh"

print_header "Installing Git"

print_info "Installing Git..."

sudo apt install -y git

print_success "Git installed."
