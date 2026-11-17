#!/usr/bin/env bash

set -o pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

print_header() { printf '\n== %s ==\n' "$1"; }
print_info() { printf '[INFO] %s\n' "$1"; }
print_success() { printf '[OK] %s\n' "$1"; }
print_warning() { printf '[WARN] %s\n' "$1" >&2; }
print_error() { printf '[ERROR] %s\n' "$1" >&2; }
command_exists() { command -v "$1" >/dev/null 2>&1; }

tool_is_installed() {
  case "$1" in
    ripgrep) command_exists rg ;;
    fd) command_exists fd || command_exists fdfind ;;
    bat) command_exists bat || command_exists batcat ;;
    neovim) command_exists nvim ;;
    fontconfig) command_exists fc-cache ;;
    *) command_exists "$1" ;;
  esac
}

run_privileged() {
  if (( EUID == 0 )); then
    "$@"
  elif command_exists sudo; then
    sudo "$@"
  else
    print_error "Install packages as root or install sudo first."
    return 1
  fi
}

detect_package_manager() {
  if [[ -n "${LINUX_SETUP_PACKAGE_MANAGER:-}" ]]; then
    case "$LINUX_SETUP_PACKAGE_MANAGER" in
      apt|apt-get|dnf|dnf5|microdnf|yum|pacman|zypper|apk|xbps|emerge|nix|guix|brew)
        case "$LINUX_SETUP_PACKAGE_MANAGER" in
          apt-get) printf apt ;; xbps) printf xbps-install ;;
          dnf5|microdnf|yum) printf dnf ;;
          *) printf '%s\n' "$LINUX_SETUP_PACKAGE_MANAGER" ;;
        esac
        return 0 ;;
      *) print_error "Unknown LINUX_SETUP_PACKAGE_MANAGER: $LINUX_SETUP_PACKAGE_MANAGER"; return 1 ;;
    esac
  fi

  local manager
  for manager in apt-get dnf dnf5 microdnf yum pacman zypper apk xbps-install emerge nix guix brew; do
    if command_exists "$manager"; then
      case "$manager" in
        apt-get) manager=apt ;;
        dnf5|microdnf|yum) manager=dnf ;;
      esac
      printf '%s\n' "$manager"
      return 0
    fi
  done
  return 1
}

package_name() {
  local manager="$1" tool="$2"
  case "$manager:$tool" in
    apt:zsh) printf zsh ;; apt:git) printf git ;; apt:tmux) printf tmux ;;
    apt:curl) printf curl ;; apt:wget) printf wget ;; apt:neovim) printf neovim ;;
    apt:fzf) printf fzf ;; apt:ripgrep) printf ripgrep ;; apt:fd) printf fd-find ;;
    apt:eza) printf eza ;; apt:bat) printf bat ;; apt:zoxide) printf zoxide ;;
    apt:btop) printf btop ;; apt:tree) printf tree ;; apt:xclip) printf xclip ;;
    apt:fontconfig) printf fontconfig ;; apt:fastfetch) printf fastfetch ;;

    dnf:zsh) printf zsh ;; dnf:git) printf git ;; dnf:tmux) printf tmux ;;
    dnf:curl) printf curl ;; dnf:wget) printf wget ;; dnf:neovim) printf neovim ;;
    dnf:fzf) printf fzf ;; dnf:ripgrep) printf ripgrep ;; dnf:fd) printf fd-find ;;
    dnf:eza) printf eza ;; dnf:bat) printf bat ;; dnf:zoxide) printf zoxide ;;
    dnf:btop) printf btop ;; dnf:tree) printf tree ;; dnf:xclip) printf xclip ;;
    dnf:fontconfig) printf fontconfig ;; dnf:fastfetch) printf fastfetch ;;

    pacman:zsh) printf zsh ;; pacman:git) printf git ;; pacman:tmux) printf tmux ;;
    pacman:curl) printf curl ;; pacman:wget) printf wget ;; pacman:neovim) printf neovim ;;
    pacman:fzf) printf fzf ;; pacman:ripgrep) printf ripgrep ;; pacman:fd) printf fd ;;
    pacman:eza) printf eza ;; pacman:bat) printf bat ;; pacman:zoxide) printf zoxide ;;
    pacman:btop) printf btop ;; pacman:tree) printf tree ;; pacman:xclip) printf xclip ;;
    pacman:fontconfig) printf fontconfig ;; pacman:fastfetch) printf fastfetch ;;

    zypper:zsh) printf zsh ;; zypper:git) printf git ;; zypper:tmux) printf tmux ;;
    zypper:curl) printf curl ;; zypper:wget) printf wget ;; zypper:neovim) printf neovim ;;
    zypper:fzf) printf fzf ;; zypper:ripgrep) printf ripgrep ;; zypper:fd) printf fd ;;
    zypper:eza) printf eza ;; zypper:bat) printf bat ;; zypper:zoxide) printf zoxide ;;
    zypper:btop) printf btop ;; zypper:tree) printf tree ;; zypper:xclip) printf xclip ;;
    zypper:fontconfig) printf fontconfig ;; zypper:fastfetch) printf fastfetch ;;

    apk:zsh) printf zsh ;; apk:git) printf git ;; apk:tmux) printf tmux ;;
    apk:curl) printf curl ;; apk:wget) printf wget ;; apk:neovim) printf neovim ;;
    apk:fzf) printf fzf ;; apk:ripgrep) printf ripgrep ;; apk:fd) printf fd ;;
    apk:eza) printf eza ;; apk:bat) printf bat ;; apk:zoxide) printf zoxide ;;
    apk:btop) printf btop ;; apk:tree) printf tree ;; apk:xclip) printf xclip ;;
    apk:fontconfig) printf fontconfig ;; apk:fastfetch) printf fastfetch ;;

    xbps-install:zsh) printf zsh ;; xbps-install:git) printf git ;; xbps-install:tmux) printf tmux ;;
    xbps-install:curl) printf curl ;; xbps-install:wget) printf wget ;; xbps-install:neovim) printf neovim ;;
    xbps-install:fzf) printf fzf ;; xbps-install:ripgrep) printf ripgrep ;; xbps-install:fd) printf fd ;;
    xbps-install:eza) printf eza ;; xbps-install:bat) printf bat ;; xbps-install:zoxide) printf zoxide ;;
    xbps-install:btop) printf btop ;; xbps-install:tree) printf tree ;; xbps-install:xclip) printf xclip ;;
    xbps-install:fontconfig) printf fontconfig ;; xbps-install:fastfetch) printf fastfetch ;;

    emerge:zsh) printf app-shells/zsh ;; emerge:git) printf dev-vcs/git ;; emerge:tmux) printf app-misc/tmux ;;
    emerge:curl) printf net-misc/curl ;; emerge:wget) printf net-misc/wget ;; emerge:neovim) printf app-editors/neovim ;;
    emerge:fzf) printf app-shells/fzf ;; emerge:ripgrep) printf sys-apps/ripgrep ;; emerge:fd) printf sys-apps/fd ;;
    emerge:eza) printf app-misc/eza ;; emerge:bat) printf sys-apps/bat ;; emerge:zoxide) printf app-shells/zoxide ;;
    emerge:btop) printf sys-process/btop ;; emerge:tree) printf app-text/tree ;; emerge:xclip) printf x11-misc/xclip ;;
    emerge:fontconfig) printf media-libs/fontconfig ;; emerge:fastfetch) printf app-misc/fastfetch ;;

    nix:zsh) printf nixpkgs#zsh ;; nix:git) printf nixpkgs#git ;; nix:tmux) printf nixpkgs#tmux ;;
    nix:curl) printf nixpkgs#curl ;; nix:wget) printf nixpkgs#wget ;; nix:neovim) printf nixpkgs#neovim ;;
    nix:fzf) printf nixpkgs#fzf ;; nix:ripgrep) printf nixpkgs#ripgrep ;; nix:fd) printf nixpkgs#fd ;;
    nix:eza) printf nixpkgs#eza ;; nix:bat) printf nixpkgs#bat ;; nix:zoxide) printf nixpkgs#zoxide ;;
    nix:btop) printf nixpkgs#btop ;; nix:tree) printf nixpkgs#tree ;; nix:xclip) printf nixpkgs#xclip ;;
    nix:fontconfig) printf nixpkgs#fontconfig ;; nix:fastfetch) printf nixpkgs#fastfetch ;;
    guix:*) printf '%s' "$tool" ;;
    brew:*) printf '%s' "$tool" ;;
    *) return 1 ;;
  esac
}

install_package_batch() {
  local manager="$1"; shift
  (($#)) || return 0
  case "$manager" in
    apt) run_privileged apt-get install -y -- "$@" ;;
    dnf)
      if command_exists dnf; then run_privileged dnf install -y -- "$@"
      elif command_exists dnf5; then run_privileged dnf5 install -y -- "$@"
      elif command_exists microdnf; then run_privileged microdnf install -y -- "$@"
      elif command_exists yum; then run_privileged yum install -y -- "$@"
      else print_error "No dnf-compatible package command is available."; return 1; fi ;;
    pacman) run_privileged pacman -S --needed --noconfirm -- "$@" ;;
    zypper) run_privileged zypper --non-interactive install --auto-agree-with-licenses "$@" ;;
    apk) run_privileged apk add -- "$@" ;;
    xbps-install) run_privileged xbps-install -y -- "$@" ;;
    emerge) run_privileged emerge --ask=n -- "$@" ;;
    nix) nix profile install "$@" ;;
    guix) guix install "$@" ;;
    brew) brew install "$@" ;;
    *) print_error "No installer for package manager '$manager'."; return 1 ;;
  esac
}

install_tools() {
  local manager="$1"; shift
  local tools=("$@") names=() tool name failed=0
  for tool in "${tools[@]}"; do
    if tool_is_installed "$tool"; then
      continue
    fi
    if ! name="$(package_name "$manager" "$tool")"; then
      print_warning "No '$tool' package mapping for $manager; skipping it."
      continue
    fi
    names+=("$name")
  done
  if ((${#names[@]})); then
    print_info "Installing with $manager: ${names[*]}"
    install_package_batch "$manager" "${names[@]}" || failed=1
  fi
  return "$failed"
}

backup_and_copy() {
  local source="$1" destination="$2"
  [[ -f "$source" ]] || { print_warning "Missing repo file: $source"; return 0; }
  mkdir -p "$(dirname "$destination")"
  if [[ -f "$destination" ]] && ! cmp -s "$source" "$destination"; then
    local backup_root="${XDG_STATE_HOME:-$HOME/.local/state}/linux-dev-setup/backups/$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_root/$(dirname "${destination#"$HOME"/}")"
    cp -a "$destination" "$backup_root/${destination#"$HOME"/}"
    print_info "Backed up existing ${destination#"$HOME"/} to $backup_root"
  fi
  if [[ ! -f "$destination" ]] || ! cmp -s "$source" "$destination"; then
    install -m 0644 "$source" "$destination"
  fi
}

clone_if_missing() {
  local repository="$1" destination="$2"
  if [[ -d "$destination/.git" ]]; then
    return 0
  elif [[ -e "$destination" ]]; then
    print_warning "$destination exists but is not a Git checkout; leaving it untouched."
    return 0
  fi
  command_exists git || { print_warning "git is unavailable; cannot fetch $repository"; return 1; }
  mkdir -p "$(dirname "$destination")"
  git clone --depth 1 "$repository" "$destination"
}
