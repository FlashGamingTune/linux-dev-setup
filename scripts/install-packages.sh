#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "$0")/lib.sh"

read_tools() {
  local file="$1" line
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" == \#* ]] || printf '%s\n' "$line"
  done < "$file"
}

requested_group="${1:-all}"
manager="$(detect_package_manager)" || {
  print_warning "No supported package manager found. Config files will still be restored."
  exit 3
}

print_info "Using package manager: $manager"
core_tools=($(read_tools "$REPO_ROOT/packages/core.txt"))
optional_tools=($(read_tools "$REPO_ROOT/packages/optional.txt"))
core_failed=0
case "$requested_group" in
  core)
    install_tools "$manager" "${core_tools[@]}" || core_failed=1 ;;
  optional)
    for tool in "${optional_tools[@]}"; do
      install_tools "$manager" "$tool" || print_warning "Could not install optional tool: $tool"
    done ;;
  all)
    install_tools "$manager" "${core_tools[@]}" || core_failed=1
    for tool in "${optional_tools[@]}"; do
      install_tools "$manager" "$tool" || print_warning "Could not install optional tool: $tool"
    done ;;
  *)
    install_tools "$manager" "$requested_group" || core_failed=1 ;;
esac

if (( core_failed )); then
  print_warning "One or more core tools could not be installed; continuing with config restoration."
  exit 1
fi

print_success "Core packages are ready."
