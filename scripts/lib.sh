#!/usr/bin/env bash

# -------------------------------------------------
# Logging Functions
# -------------------------------------------------

print_header() {
  echo
  echo "========================================"
  echo " $1"
  echo "========================================"
}

print_info() {
  echo "[INFO] $1"
}

print_success() {
  echo "[SUCCESS] $1"
}

print_warning() {
  echo "[WARNING] $1"
}

print_error() {
  echo "[ERROR] $1"
}

# -------------------------------------------------
# Utility Functions
# -------------------------------------------------

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

require_sudo() {
  sudo -v
}

exit_on_error() {
  if [ "$1" -ne 0 ]; then
    print_error "$2"
    exit 1
  fi
}
