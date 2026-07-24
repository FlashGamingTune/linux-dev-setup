#!/usr/bin/env bash

source "$(dirname "$0")/lib.sh"

print_header "Installing Development Tools"

print_info "Installing build tools..."

sudo apt install -y \
  build-essential \
  gcc \
  g++ \
  make \
  cmake \
  python3 \
  python3-pip \
  openjdk-21-jdk

print_success "Development tools installed."
